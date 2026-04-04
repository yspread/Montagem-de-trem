# Segmento de dados
	.data
	.align 0
mens: 	.asciz "Bem vindo ao jogo Montagem de Trem!\n"
	.align 0
menu:	.asciz "Selecione um dos comandos para jogar:\n1. Adicionar no início\n2. Adicionar no final\n3. Remover por ID\n4. Listar\n5. Buscar\n6. Sair\nEscolha Atual: "
	.align 0
mens_id:
	.asciz "Digite o id do vagão: "
	.align 0
mens_tipo:
	.asciz "Digite o tipo do vagão:\n(2) Carga\n(3) Passageiro\n(4) Combustível\nEscolha Atual: "
mens_nao_encontrado: 
	.asciz "Erro: Vagão com este ID não encontrado!\n"
mens_remocao_primeiro:
	.asciz "Erro: Não é possível remover a locomotiva\n"
mens_erro_menu:
	.asciz "Erro: Comando inválido!\n"
mens_erro_tipo:
	.asciz "Erro: Tipo inválido|!\n"
mens_vagao_encontrado:
	.asciz "O vagão com o ID procurado existe\n"
mens_print_id:
	.asciz "\nID: "
mens_print_tipo:
	.asciz "\nTipo do Vag�o: "

#Definição e inicialização da locomotiva
locomotiva:
	.align 2
	.word 0 #id zero
	.align 2
	.word 1 #tipo 1 = locomotiva
	.align 2
	.word 0 #ponteiro para o próximo inicialmente "zerado"

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
	
	
	# Se não foi selecionado um comando inválido, avisa o erro e imprime o menu novamente
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
	addi a7,zero,10
	ecall



# Definição dos Procedimentos

# FUNCIONALIDADE 1
adicionar_inicio:
	# Alocando memória para o vagão (12bytes)
	addi a7,zero,9
	addi a0,zero,12
	ecall
	mv t2,a0
	# Solicitação do id e tipo do vagão
	addi a7,zero,4
	la a0,mens_id
	ecall
	addi a7,zero,5
	ecall
	mv t3, a0
	sw t3,0(t2) # inicializando o id do vagão
ler_tipo_1:
	addi a7,zero,4
	la a0,mens_tipo
	ecall
	addi a7,zero,5
	ecall
	addi t4, zero, 4 # valor m�ximo para o tipo do vag�o
	bgt a0, t4, tipo_invalido_1  # se o tipo inserido for maior que o valor m�ximo, tratamos o erro
	addi t4, zero, 1 # o tipo 1 corresponde a locomotiva, n�o � poss�vel adicionar outras locomotivas no trem
	ble a0, t4, tipo_invalido_1
	
	mv t4, a0 # se o tipo for v�lido, prosseguimos
	sw t4,4(t2) # inicializando o tipo do vagão
	# Reorganização dos ponteiros
	la t0, locomotiva #obtendo o endereço da locomotiva e colocando em t0
	lw t1, 8(t0) #obtendo o endereço que o ponteiro da locomotiva apontava anteriormente e colocando em t1
	sw t2, 8(t0) #colocando o endereço do novo vagão(t2) no ponteiro da locomotiva
	sw t1, 8(t2) #inicializando o ponteiro do vagão
	
	# Retornando do procedimentop
	jr ra
	
tipo_invalido_1: 
	addi a7,zero,4 # caso o tipo do vag�o inserido seja inv�lido, avisamos e pedimos novamente que um tipo seja inserido, at� ser um tipo v�lido
	la a0,mens_erro_tipo
	ecall
	
	j ler_tipo_1 # pede novamente que se insira o tipo do vag�o


# FUNCIONALIDADE 2
adicionar_fim:
	la t0, locomotiva # obtendo o endereço da locomotiva e colocando em t0

encontrar_fim:
	lw t1, 8(t0)          # obtendo o endereço que o ponteiro do t0 apontava anteriormente e colocando em t1
	beq t1,zero,adicionar # se t1=0, t0 é o último vagão
	mv t0, t1             # senão, continua a percorrer a lista

	j encontrar_fim

adicionar:
	# Alocando memória para o vagão (12bytes)
	addi a7,zero,9
	addi a0,zero,12
	ecall
	mv t2,a0
	# Solicitação do id e tipo do vagão
	addi a7,zero,4
	la a0,mens_id
	ecall
	addi a7,zero,5
	ecall
	mv t3, a0
	sw t3,0(t2) # inicializando o id do vagão
ler_tipo_2:
	addi a7,zero,4
	la a0,mens_tipo
	ecall
	addi a7,zero,5
	ecall
	# aqui � feita a verifica��o de se o tipo inserido � valido ou n�o, igual na funcionalidade 1
	addi t4, zero, 4 
	bgt a0, t4, tipo_invalido_2
	addi t4, zero, 1 
	ble a0, t4, tipo_invalido_2
	# caso o tipo seja v�lido, prosseguimos
	mv t4, a0
	sw t4,4(t2)    # inicializando o tipo do vagão
	sw zero, 8(t2) # novo vagão aponta para 0
	sw t2, 8(t0)   # colocando o endereço do novo vagão(t2) no ponteiro do antigo último vagão

	# Retornando do procedimento
	jr ra
tipo_invalido_2:
	addi a7,zero,4 # caso o tipo do vag�o inserido seja inv�lido, avisamos e pedimos novamente que um tipo seja inserido, at� ser um tipo v�lido
	la a0,mens_erro_tipo
	ecall
	
	j ler_tipo_2 # pedimos o tipo novamente

# FUNCIONALIDADE 3
remover_vagao_id:
	la t0, locomotiva # obtendo o endereço da locomotiva e colocando em t0
	# Solicitação do id
	addi a7,zero,4
	la a0,mens_id
	ecall
	addi a7,zero,5
	ecall
	mv t2, a0
	beq t2,zero,primeiro_vagao # verificando se o vagão a ser removido é a locomotiva

encontrar_vagao:
	lw t1, 8(t0)                     # obtendo o endereço que o ponteiro do t0 apontava anteriormente e colocando em t1
	beq t1,zero,vagao_nao_encontrado # se t1=0, não achou o vagão
	lw t3, 0(t1)                     # obtendo o ID do vagão atual
    beq t3,t2,remocao                # Se ID do vagão == ID buscado, remove!
	mv t0, t1                        # senão continua a percorrer

	j encontrar_vagao

remocao:
	lw t4, 8(t1)               # obtendo o endereço que o ponteiro do t1 aponta e colocando em t4
	sw t4, 8(t0)               # o vagão anterior aponta para o vagão que o que está sendo removido apontava (ou aponta para 0)
	sw zero, 8(t1)             # o vagão removido aponta para 0

	# Retornando do procedimento
	jr ra

vagao_nao_encontrado:
	addi a7, zero, 4        
    la a0, mens_nao_encontrado 
    ecall

	# Retornando do procedimento
    jr ra

primeiro_vagao:
	addi a7, zero, 4        
    la a0, mens_remocao_primeiro 
    ecall

	# Retornando do procedimento
    jr ra



# FUNCIONALIDADE 4
listar_trem:
	la t0, locomotiva # pegando o endereço da locomotiva
	lw t1, 8(t0) # pegando o valor que a locomotiva aponta (primeiro vagão)

percorrer_e_printar:
	lw t2, 0(t1) # salvo o id do vagão
	addi a7, zero, 4
	la, a0, mens_print_id
	ecall
	addi a7,zero,1 # imprimo o ID do vagão
	mv a0, t2
	ecall
	addi a7, zero, 4
	la, a0, mens_print_tipo
	ecall
	lw t2, 4(t1) # salvo o tipo do vagão
	addi a7,zero,1	# imprimo o tipo do vagão
	mv a0, t2
	ecall
	addi, a7, zero, 11 # imprimo uma quebra de linha
	li a0, 10 # salvo o valor ASCII de \n no registrador 
	ecall
	lw t1, 8(t1) # salvo o endereço do próximo vagão
	bne t1, zero, percorrer_e_printar # se não for o fim do trem, eu repito o processo para o próximo vagão

	# Retornando do procedimento
	jr ra


# FUNCIONALIDADE 5
buscar_vagao:
	addi a7,zero,4 # peço pro usuário que digite o ID a ser buscado
	la a0,mens_id
	ecall
	addi a7,zero,5	#leitura do input do usuário (ID do vagão procurado)
	ecall
	mv t0, a0 # armazeno o ID a ser buscado em t0
	la t1, locomotiva # pegando o endereço da locomotiva
	lw t2, 8(t1) # pegando a posição do primeiro vagão

percorrer_trem:
	lw t3, 0(t2) # pego o id do vagão
	beq t3, t0, id_encontrado # se os IDs são correspondentes, saio do loop
	lw t2, 8(t2) # caso não, passo pro próximo vagão
	bne t2, zero, percorrer_trem # enquanto não acabar o trem e o ID não for encontrado, continuo o loop
	addi a7, zero, 4
	la a0, mens_nao_encontrado # nesse caso, chegamos no fim do trem e o ID não foi encontrado
	ecall

	# Retornando do procedimento
	jr ra

id_encontrado:
	addi a7, zero, 4
	la a0, mens_vagao_encontrado #o vagão foi encontrado e relatamos isso ao usuário
	ecall

	#Retornando do procedimento
	jr ra
