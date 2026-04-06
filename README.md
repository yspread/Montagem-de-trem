# Montagem-de-trem
Trabalho 1 para a disciplina de Organização e Arquitetura de Computadores, com a professora Sarita no ICMC USP

### Integrantes do grupo
Rafael Pavon Diesner - 16898096

Gustavo de Faria Fernandes - 16871221

Giovanni Torres Bullo - 16869833

# Introdução e objetivos
O projeto consiste na implementação em assembly RISC-V de um simples jogo chamado "Montagem de Trem", no qual o jogador controla um trem, podendo adicionar e remover vagões. O trem é representado por meio de uma lista encadeada, na qual cada vagão corresponde a um nó. Cada vagão possui um ID único e um tipo, representado por um inteiro: 1 - locomotiva, 2 - cargueiro, 3 - transporte de passageiros e 4 - armazenamento de combustível.

# Segmento de dados
O segmento de dados se baseia na definição de diversas strings que serão impressas durante o programa. Além disso, é feito a definição da locomotiva e inicialização dela.

# Programa principal
A base do programa é um "loop" da impressão de um menu de comandos que o jogador pode realizar. A cada execução do "loop", é lido do jogador um valor inteiro que representa o comando escolhido, esse valor será utilizado em uma espécie de "switch case" em que se utiliza a instrução "beq" (branch if equal) para mudar o fluxo de execução do programa para uma "branch" associada à aquele comando. Em cada "branch", se utiliza a instrução jal (jump and link) para iniciar o procedimento associado à aquele comando, após a execução do procedimento se utiiza jr (jump register) para retornar à branch do comando e, por fim, se utiliza um jump incondicional para retornar ao loop do menu.

# Funcionalidade 1
A funcionalidade 1 se baseia em adicionar um vagão no início do trem, ou seja, logo após a locomotiva. Para isso, primeiro é utilizado a chamada ao sistema para alocar 12bytes de memória de forma dinâmica que corresponde ao vagão. Em seguida, se utiliza diferentes "branches" para, respectivamente, ler o id do vagão fornecido pelo jogador, verificar se esse id já não existe, ler o tipo do vagão fornecido pelo jogador e verificar se o tipo é válido. Nessas verificações de id e tipo, se o id já existir, é solicitado um novo, o mesmo é feito caso o tipo seja inválido. Ao final de tudo isso, é feita a realocação de ponteiros, o ponteiro do novo vagão aponta para o que a locomotiva apontava, já o da locomotiva vai apontar para o novo vagão.

# Funcionalidade 2

# Funcionalidade 3

# Funcionalidade 4

# Funcionalidade 5

