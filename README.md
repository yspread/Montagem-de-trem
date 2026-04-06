# Montagem-de-trem
Trabalho 1 para a disciplina de Organização e Arquitetura de Computadores, com a professora Sarita no ICMC USP

### Integrantes do grupo
Rafael Pavon Diesner - 16898096

Gustavo de Faria Fernandes - 16871221

Giovanni Torres Bullo - 16869833

# Introdução e objetivos
O projeto consiste na implementação em assembly RISC-V de um simples jogo chamado "Montagem de Trem", no qual o jogador controla um trem, podendo adicionar e remover vagões. O trem é representado por meio de uma lista encadeada, na qual cada vagão corresponde a um nó. Cada vagão possui um ID único e um tipo, representado por um inteiro: 1 - locomotiva, 2 - cargueiro, 3 - transporte de passageiros e 4 - armazenamento de combustível.

# Segmento de dados
O segmento de dados se baseia na definição de diversas strings que serão impressas durante o programa, como mensagens de erro, por exemplo. Além disso, é feito a definição da locomotiva e inicialização dela.

# Programa principal
A base do programa é um "loop" da impressão de um menu de comandos que o jogador pode realizar. A cada execução do "loop", é lido do jogador um valor inteiro que representa o comando escolhido, esse valor será utilizado em uma espécie de "switch case" em que se utiliza a instrução "beq" (branch if equal) para mudar o fluxo de execução do programa para uma "label" associada à aquele comando. Em cada "label", se utiliza a instrução jal (jump and link) para iniciar o procedimento associado à aquele comando, após a execução do procedimento se utiiza jr (jump register) para retornar à branch do comando e, por fim, se utiliza um jump incondicional para retornar ao loop do menu.

# Funcionalidade 1
A funcionalidade 1 se baseia em adicionar um vagão no início do trem, ou seja, logo após a locomotiva. Para isso, primeiro é utilizado a chamada ao sistema para alocar 12bytes de memória de forma dinâmica que corresponde ao vagão. Em seguida, se utiliza diferentes "labels" para, respectivamente, ler o id do vagão fornecido pelo jogador, verificar se esse id já não existe, ler o tipo do vagão fornecido pelo jogador e verificar se o tipo é válido. Nessas verificações de id e tipo, se o id já existir, é solicitado um novo, o mesmo é feito caso o tipo seja inválido. Ao final de tudo isso, é feita a realocação de ponteiros, o ponteiro do novo vagão aponta para o que a locomotiva apontava, já o da locomotiva vai apontar para o novo vagão. Implementamos o programa de modo que não se pode adicionar outros vagões do tipo locomotiva, sendo esse tipo exclusivo do primeiro vagão.

# Funcionalidade 2
A funcionalidade 2 se baseia em adicionar um vagão no final do trem. Para isso, assim como na funcionalidade 1 é alocado 12 bytes de memória, verifica-se se o id lido já existe no trem, além de ler e verificar o tipo do vagão. Se o id já existir ou o tipo do vagão for inválido, é solicitado um novo id ou tipo, respectivamente. Antes de adicionar o vagão, é necessário percorrer o trem para achar o último nó, e então o vagão é adicionado.

# Funcionalidade 3
A funcionalidade 3 se baseia em remover um vagão a partir de um id fornecido pelo usuário. Para isso, primeiro há a verificação se o id fornecido corresponde ao id da locomotiva, em caso positivo é informado a proibição de remove-lo. Após isso o programa percorre a lista a fim de achar o nó correspondente e realoca os ponteiros. Como a realocação se baseia em fazer o vagão anterior ao removido apontar para o vagão posterior ao mesmo, e fazer o vagão removido apontar para nulo, não é preciso diferenciar entre os casos de remover no meio ou remover no fim.

# Funcionalidade 4
A funcionalidade 4 consiste em percorrer toda a locomotiva imprimindo o ID e o tipo (1 - locomotiva, 2 - cargueiro, 3 - transporte de passageiros e 4 - armazenamento de combustível) de todos os vagões, inclusive da locomotiva. Para isso, é feito um loop que consiste em imprimir esses campos e no final de cada etapa do loop nós manipulamos os registradores para armazenar o endereço do próximo vagão na memória, repetindo o processo até chegar no ultimo vagão (onde o ponteiro para o próximo vagão vale zero)

# Funcionalidade 5
Na funcionalidade 5, o usuário insere um valor de ID e o programa informa se existe no trem um vagão com esse ID ou não. Para isso, fazemos um loop que percorre por todo o trem e em cada vagão que o loop passa, seu ID é comparado com o valor inserido pelo usuário. O loop se encerra quando essa comparação retorna um resultado positivo, e então o usuário é informado que o vagão procurado existe, ou então quando nenhuma comparação retornou resultado positivo, mas o loop já verificou todos os vagões, e então o programa retorna que o vagão procurado não existe.
