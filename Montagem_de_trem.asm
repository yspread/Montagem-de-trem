# Segmento de dados
	.data
	.align 0
mens: 	.asciz "Bem vindo ao jogo Montagem de Trem!\n"
	.align 0
menu:	.asciz "Selecione um dos comandos para jogar:\n1. Adicionar no início\n2. Adicionar no final\n3. Remover por ID\n4. Listar\n5. Buscar\n6. Sair\nEscolha Atual: "
	.align 0
mens_id:
	.asciz "Digite o ID do vagão: "
	.align 0
mens_tipo:
	.asciz "Digite o tipo do vagão:\n(2) Carga\n(3) Passageiro\n(4) Combustível\nEscolha Atual: "
mens_nao_encontrado: 
	.asciz "Erro: Vagão com este ID não encontrado!\n"
mens_remocao_primeiro:
	.asciz "Erro: Não é possível remover a locomotiva\n"
mens_id_repetido:
	.asciz "Erro: Já existe vagão com o ID informado, digite outro valor!\n"
mens_erro_menu:
	.asciz "Erro: Comando inválido!\n"
mens_erro_tipo:
	.asciz "Erro: Tipo inválido|!\n"
mens_vagao_encontrado:
	.asciz "O vagão com o ID procurado existe\n"
mens_print_id:
	.asciz "\nID: "
mens_print_tipo:
	.asciz "\nTipo do Vagão: "

#Definição e inicialização da locomotiva
locomotiva:
	.align 2
	.word 0 											#id zero
	.align 2
	.word 1 											#tipo 1 = locomotiva
	.align 2
	.word 0 											#ponteiro para o próximo inicialmente "zerado"

# Segmento de texto
	.text
	.align 2
	.globl main

# Programa principal
main:	
	# Impressão a mensagem de boas vindas
	addi a7,zero,4
	la a0,mens
	ecall
	
# Loop para impressão do menu e escolha do comando
loop_menu: 
	# Impressão do menu
	addi a7,zero,4
	la a0,menu
	ecall
	# Leitura do comando
	addi a7,zero,5
	ecall
	mv t0, a0
	
	# "Switch case" dos comandos
	addi t1,zero,1
	beq t0,t1,com1
	addi t1,t1,1
	beq t0,t1,com2
	addi t1,t1,1
	beq t0,t1,com3
	addi t1,t1,1
	beq t0,t1,com4
	addi t1,t1,1
	beq t0,t1,com5
	addi t1,t1,1
	beq t0,t1,com6
	
	
	# Se foi selecionado um comando inválido, avisa o erro e imprime o menu novamente
	addi a7,zero,4
	la a0,mens_erro_menu
	ecall
	j loop_menu
	
# Definição dos comandos
com1:
	jal adicionar_inicio
	j loop_menu
com2:
	jal adicionar_fim
	j loop_menu
com3:
	jal remover_vagao_id
	j loop_menu
com4:
	jal listar_trem
	j loop_menu
com5:
	jal buscar_vagao
	j loop_menu
com6:
	addi a7,zero,10										# Saída do programa
	ecall



# Definição dos Procedimentos

# FUNCIONALIDADE 1 -> Adiciona um vagão no ínício do trem, logo após a locomotiva
adicionar_inicio:
	# Alocando memória para o vagão (12bytes)
	addi a7,zero,9
	addi a0,zero,12
	ecall
	mv t2,a0 											# endereço de memória alocado para o novo vagão salvo em t2
ler_id_1: 												# solitação para que o usuário insira o ID do novo vagão
	addi a7,zero,4
	la a0,mens_id
	ecall
	addi a7,zero,5
	ecall
	mv t3, a0
	la t4, locomotiva									# endereço da locomotiva salvo em t4
procura_id_repetido:									# loop para verificar se o ID é novo ou se já existe um vagão com esse ID. Caso exista, o ID é inválido e portanto deve ser inserido um novo ID
	lw t5, 0(t4) 										# salvo o id do vagão atual em t5
	beq t3, t5, id_repetido_1 							# se o id inserido for igual ao do vagão já existente, o id é invalido
	lw t4, 8(t4) 										# salvo o endereço pro próximo vagão
	bne t4, zero, procura_id_repetido 					# se não chegou no ultimo vagão ainda e o id ainda não foi repetido, continuamos o loop ate o fim do trem ou ate achar um id repetido
	sw t3,0(t2) 										# inicializando o id do vagão, caso o id não seja repetido
ler_tipo_1:
	addi a7,zero,4										# solicitação para que o usuário insira o tipo do novo vagão
	la a0,mens_tipo
	ecall
	addi a7,zero,5
	ecall
	addi t4, zero, 4 									# o valor correspondente ao tipo do vagão inserido deve ser 2, 3 ou 4
	bgt a0, t4, tipo_invalido_1  						# se o tipo inserido for maior que o valor máximo, tratamos o erro
	addi t4, zero, 1 									# o tipo 1 corresponde a locomotiva, não é possível adicionar outras locomotivas no trem
	ble a0, t4, tipo_invalido_1
	mv t4, a0 											# se o tipo for válido, prosseguimos
	sw t4,4(t2) 										# inicializando o tipo do vagão
	# Reorganização dos ponteiros
	la t0, locomotiva 									# obtendo o endereço da locomotiva e colocando em t0
	lw t1, 8(t0) 										# obtendo o endereço que o ponteiro da locomotiva apontava anteriormente e colocando em t1
	sw t2, 8(t0) 										# colocando o endereço do novo vagão(t2) no ponteiro da locomotiva
	sw t1, 8(t2) 										# inicializando o ponteiro do vagão
	
	# Retornando do procedimento
	jr ra
	
id_repetido_1:
	addi a7, zero, 4
	la a0, mens_id_repetido 							# caso o id já exista na lista, o usuário é informado do erro e é pedido um novo id
	ecall
	
	j ler_id_1
	
tipo_invalido_1: 
	addi a7,zero,4 										# caso o tipo do vagão inserido seja inválido, avisamos e pedimos novamente que um tipo seja inserido, até ser um tipo válido
	la a0,mens_erro_tipo
	ecall
	
	j ler_tipo_1 


# FUNCIONALIDADE 2 -> Adiciona um vagão ao final do trem
adicionar_fim:
	# Alocando memória para o vagão (12bytes)
	addi a7,zero,9
	addi a0,zero,12
	ecall
	mv t1,a0 										# guardo o endereço alocado em t1
ler_id_2:											# Solicitação do id do vagão
	addi a7,zero,4
	la a0,mens_id
	ecall
	addi a7,zero,5
	ecall
	mv t2, a0  										# em t2 fica salvo o id do vagão a ser inserido
	la t0, locomotiva 								# obtendo o endereço da locomotiva e colocando em t0
encontrar_fim:		      							# loop para chegar no fim do trem onde será adicionado o novo vagão, o loop também serve para verificar se o ID digitado pelo usuário é repetido (inválido) ou não
	lw t3, 0(t0)          							# obtendo o valor do id do vagão atual e salvando em t3
	beq t2, t3, id_invalido_2 						# se o id inserido é igual ao t3, pedimos por um novo id
	lw t5, 8(t0)             						# devemos salvar o endereço do vagão pois ele será necessário caso seja o último
	beq t5, zero, continua_insercao 				# se o proximo vagão for nulo, é por que chegamos no final sem encontrar id repetido, então podemos prosseguir com a inserção
	mv t0, t5  	 									# caso o vagão atual não seja o último, passamos o endereço dele para o t0 para continuar o loop da forma correta
	j encontrar_fim
	# continuando a inserção, após ser encontrado o final do trem
continua_insercao:
	sw t2,0(t1) 									# inicializando o id do vagão
ler_tipo_2: 										# Solicitação do tipo do vagão
	addi a7,zero,4
	la a0,mens_tipo
	ecall
	addi a7,zero,5
	ecall
	# aqui é feita a verificação de se o tipo inserido é valido ou não, igual na funcionalidade 1
	addi t3, zero, 4 
	bgt a0, t3, tipo_invalido_2
	addi t3, zero, 1 
	ble a0, t3, tipo_invalido_2
	# caso o tipo seja válido, prosseguimos
	mv t4, a0
	sw t4,4(t1)    									# inicializando o tipo do vagão
	sw zero, 8(t1) 									# novo vagão aponta para 0
	sw t1, 8(t0)   									# colocando o endereço do novo vagão(t2) no ponteiro do antigo último vagão

	# Retornando do procedimento
	jr ra
	
id_invalido_2:
	addi a7, zero, 4
	la a0, mens_id_repetido       					# caso o id já exista na lista, relatamos o erro e lemos um novo id
	ecall
	
	j ler_id_2
	
tipo_invalido_2:
	addi a7,zero,4 									# caso o tipo do vagão inserido seja inválido, avisamos e pedimos novamente que um tipo seja inserido, até ser um tipo válido
	la a0,mens_erro_tipo
	ecall
	
	j ler_tipo_2



# FUNCIONALIDADE 3 -> Um ID é solicitado ao usuário e o vagão com o ID inserido é removido do trem
remover_vagao_id:
	la t0, locomotiva 								# obtendo o endereço da locomotiva e colocando em t0
ler_id_3:											# Solicitação do id do vagão
	addi a7,zero,4
	la a0,mens_id
	ecall
	addi a7,zero,5
	ecall
	mv t2, a0
	beq t2,zero,primeiro_vagao 						# verificando se o vagão a ser removido é a locomotiva (ID = 0). Caso seja, não pode ser removido
	# início do loop para procurar o vagão desejado
encontrar_vagao:
	lw t1, 8(t0)                     				# obtendo o endereço que o ponteiro do t0 apontava anteriormente e colocando em t1
	beq t1,zero,vagao_nao_encontrado 				# se t1=0, chegamos ao fim do trem e o vagão procurado não foi encontrado
	lw t3, 0(t1)                     				# obtendo o ID do vagão atual
    	beq t3,t2,remocao                			# Se ID do vagã0 = ID buscado, prosseguimos com a remoção
	mv t0, t1                        				# senão continua a percorrer
	j encontrar_vagao
	
remocao:
	lw t4, 8(t1)               						# obtendo o endereço que o ponteiro do t1 aponta e colocando em t4
	sw t4, 8(t0)               						# o vagão anterior aponta para o vagão que o que está sendo removido apontava (ou aponta para 0 caso o removido fosse o último vagão)
	sw zero, 8(t1)             						# o vagão removido aponta para 0

	# Retornando do procedimento
	jr ra

vagao_nao_encontrado:								# caso o ID a ser removido não exista no trem, avisamos o usuário
	addi a7, zero, 4        
    	la a0, mens_nao_encontrado 
    	ecall
	
	j ler_id_3  									# pedimos um novo ID ao usuário

primeiro_vagao:
	addi a7, zero, 4        
    	la a0, mens_remocao_primeiro				# caso o ID a ser removido corresponda a locomotiva, avisamos e não permitimos
    	ecall
    	
    	j ler_id_3									# pedimos um novo id ao usuário



# FUNCIONALIDADE 4 -> Todos os vagões do trem são impressos
listar_trem:
	la t0, locomotiva 								# pegando o endereço da locomotiva
	# início do loop que percorre o trem, imprimindo os vagões
percorrer_e_printar:
	lw t1, 0(t0) 									# salvo o id do vagão
	addi a7, zero, 4
	la, a0, mens_print_id
	ecall
	addi a7,zero,1 									# imprimo o ID do vagão
	mv a0, t1
	ecall
	addi a7, zero, 4
	la, a0, mens_print_tipo
	ecall
	lw t1, 4(t0) 									# salvo o tipo do vagão
	addi a7,zero,1									# imprimo o tipo do vagÃ£o
	mv a0, t1
	ecall
	addi, a7, zero, 11 								# imprimo uma quebra de linha
	li a0, 10 										# salvo o valor ASCII de \n no registrador 
	ecall
	lw t0, 8(t0) 									# salvo o endereÃ§o do próximo vagão
	bne t0 ,zero, percorrer_e_printar 				# se não for o fim do trem, eu repito o processo para o próximo vagão

	# Retornando do procedimento
	jr ra
	


# FUNCIONALIDADE 5 -> Um ID é inserido pelo usuário e é feita a verificação de se um vagão com esse ID existe no trem ou não
buscar_vagao:
	addi a7,zero,4 									# é solicitado ao usuário que digite o ID a ser buscado
	la a0,mens_id
	ecall
	addi a7,zero,5									# leitura do input do usuário (ID do vagão procurado)
	ecall
	mv t0, a0 										# armazeno o ID a ser buscado em t0
	la t1, locomotiva 								# pegando o endereço da locomotiva
	# início do loop para percorrer o trem procurando pelo ID desejado
percorrer_trem:
	lw t2, 0(t1) 									# pego o id do vagão
	beq t2, t0, id_encontrado 						# se os IDs são correspondentes, saio do loop
	lw t1, 8(t1) 									# caso não, passo pro próximo vagão
	bne t1, zero, percorrer_trem 					# enquanto não acabar o trem e o ID não for encontrado, continuo o loop
	addi a7, zero, 4
	la a0, mens_nao_encontrado 						# nesse caso, chegamos no fim do trem e o ID não foi encontrado
	ecall

	# Retornando do procedimento
	jr ra

id_encontrado:
	addi a7, zero, 4
	la a0, mens_vagao_encontrado 					# o vagão foi encontrado e relatamos isso ao usuário
	ecall

	#Retornando do procedimento
	jr ra
