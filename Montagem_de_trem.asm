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
	
	
	# Se não foi selecionado nenhum comando, imprime o menu novamente
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
adicionar_inicio:
	# Alocando memória para o vagão (12bytes)
	addi a7,zero,9
	add a0,zero,12
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
	addi a7,zero,4
	la a0,mens_tipo
	ecall
	addi a7,zero,5
	ecall
	mv t4, a0
	sw t4,4(t2) # inicializando o tipo do vagão
	# Reorganização dos ponteiros
	la t0, locomotiva #obtendo o endereço da locomotiva e colocando em t0
	lw t1, 8(t0) #obtendo o endereço que o ponteiro da locomotiva apontava anteriormente e colocando em t1
	sw t2, 8(t0) #colocando o endereço do novo vagão(t2) no ponteiro da locomotiva
	sw t1, 8(t2) #inicializando o ponteiro do vagão
	
	# Retornando do procedimentop
	jr ra
	
adicionar_fim:
	
	
remover_vagao_id:
	

listar_trem:
	

buscar_vagao:
	