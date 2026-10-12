Algoritmo "UniLibrary"
// Disciplina  : Algoritmo e Lógica de Programação
// Professor   : André Olímpio
// Descrição   : Sistema de biblioteca (cadastro, empréstimo, devolução, ranking, estatísticas e busca recursiva)
// Autor(a)    : Nome do(a) aluno(a)
// Data atual  : 10/10/2026

// Registro que guarda todos os dados de um livro
tipo TLivro = registro
   codigo: inteiro
   titulo: caractere
   autor: caractere
   ano: inteiro
   categoria: inteiro
   qtdTotal: inteiro
   qtdDisponivel: inteiro
   qtdEmprestimos: inteiro
   status: inteiro
fimregistro

var
   //declaraçãod das variaveis e const
   MAX_LIVROS: inteiro
   MAX_CATEGORIAS: inteiro
   TECNOLOGIA: inteiro
   EXATAS: inteiro
   HUMANAS: inteiro
   NEGOCIOS: inteiro
   LITERATURA: inteiro
   DISPONIVEL: inteiro
   INDISPONIVEL: inteiro
   EMPRESTIMO: inteiro
   DEVOLUCAO: inteiro
   NAO_ACHOU: inteiro
   ANO_MIN: inteiro
   ANO_MAX: inteiro
   // Variaveis globais: acervo, matriz (categoria x emprestimo/devolucao), nomes das categorias, contador de livros e opcao do menu
   livros: vetor [1..40] de TLivro
   mov: vetor [1..5, 1..2] de inteiro
   nomeCat: vetor [1..5] de caractere
   qtdLivros: inteiro
   opcao: inteiro

// Coloca os valores iniciais em tudo
procedimento comeco
var i, j: inteiro
inicio
   // Define os valores fixos (capacidade, categorias, status, colunas da matriz, limites de ano)
   MAX_LIVROS <- 40
   MAX_CATEGORIAS <- 5
   TECNOLOGIA <- 1
   EXATAS <- 2
   HUMANAS <- 3
   NEGOCIOS <- 4
   LITERATURA <- 5
   DISPONIVEL <- 1
   INDISPONIVEL <- 0
   EMPRESTIMO <- 1
   DEVOLUCAO <- 2
   NAO_ACHOU <- 0
   ANO_MIN <- 1500
   ANO_MAX <- 2026
   // Preenche os nomes das categorias e comeca sem nenhum livro
   nomeCat[TECNOLOGIA] <- "Tecnologia"
   nomeCat[EXATAS] <- "Ciencias Exatas"
   nomeCat[HUMANAS] <- "Ciencias Humanas"
   nomeCat[NEGOCIOS] <- "Adm e Negocios"
   nomeCat[LITERATURA] <- "Literatura"
   qtdLivros <- 0
   // Zera a matriz inteira (repeticao dentro de repeticao)
   para i de 1 ate MAX_CATEGORIAS faca
      para j de 1 ate 2 faca
         mov[i, j] <- 0
      fimpara
   fimpara
fimprocedimento

// ---------------- FUNCOES ----------------

// Procura o livro pelo codigo: devolve a posicao no vetor ou 0 se nao achar
funcao procurar(cod: inteiro): inteiro
var i, posicao: inteiro
inicio
   posicao <- NAO_ACHOU
   i <- 1
   // Anda pelos livros ate acabar o vetor ou achar o codigo
   enquanto (i <= qtdLivros) e (posicao = NAO_ACHOU) faca
      se livros[i].codigo = cod entao
         posicao <- i
      fimse
      i <- i + 1
   fimenquanto
   retorne posicao
fimfuncao

// Calcula quantos exemplares do livro estao emprestados
funcao qtdEmprestada(posicao: inteiro): inteiro
inicio
   retorne livros[posicao].qtdTotal - livros[posicao].qtdDisponivel
fimfuncao

// Busca binaria recursiva: precisa do vetor ordenado por codigo
// comecoV e fimV marcam o pedaco do vetor onde estou procurando
funcao buscaRecursiva(cod, comecoV, fimV: inteiro): inteiro
var meio, resultado: inteiro
inicio
   // Caso-base 1: nao sobrou nenhuma posicao, entao o livro nao existe
   se comecoV > fimV entao
      escreval("Intervalo vazio (", comecoV, " ate ", fimV, ")")
      resultado <- NAO_ACHOU
   senao
      // Olha o livro do meio do intervalo
      meio <- (comecoV + fimV) \ 2
      escreval("Olhando a posicao ", meio, " (codigo ", livros[meio].codigo, ") no intervalo ", comecoV, " ate ", fimV)
      // Caso-base 2: achou. Senao, chama a si mesma so na metade de baixo ou so na de cima
      se livros[meio].codigo = cod entao
         resultado <- meio
      senao
         se cod < livros[meio].codigo entao
            resultado <- buscaRecursiva(cod, comecoV, meio - 1)
         senao
            resultado <- buscaRecursiva(cod, meio + 1, fimV)
         fimse
      fimse
   fimse
   retorne resultado
fimfuncao

// ---------------- PROCEDIMENTOS PEQUENOS ----------------

// Muda o status do livro: INDISPONIVEL se acabaram os exemplares, senao DISPONIVEL
procedimento atualizarStatus(posicao: inteiro)
inicio
   se livros[posicao].qtdDisponivel = 0 entao
      livros[posicao].status <- INDISPONIVEL
   senao
      livros[posicao].status <- DISPONIVEL
   fimse
fimprocedimento

// Mostra todos os dados de um livro
procedimento mostrarLivro(posicao: inteiro)
inicio
   escreval("Codigo: ", livros[posicao].codigo)
   escreval("Titulo: ", livros[posicao].titulo)
   escreval("Autor: ", livros[posicao].autor)
   escreval("Ano: ", livros[posicao].ano)
   escreval("Categoria: ", nomeCat[livros[posicao].categoria])
   escreval("Exemplares: ", livros[posicao].qtdTotal)
   escreval("Disponiveis: ", livros[posicao].qtdDisponivel)
   escreval("Emprestimos: ", livros[posicao].qtdEmprestimos)
   se livros[posicao].status = DISPONIVEL entao
      escreval("Status: DISPONIVEL")
   senao
      escreval("Status: INDISPONIVEL")
   fimse
fimprocedimento

// ---------------- CADASTRO ----------------

// Cadastra um livro novo, validando cada dado digitado
procedimento cadastrarLivro
var cod, ano, cat, quant, c: inteiro
    tit, aut: caractere
inicio
   // Se o acervo ja esta cheio, nao deixa cadastrar
   se qtdLivros >= MAX_LIVROS entao
      escreval("ERRO: o acervo ja esta cheio!")
   senao
      // Pede o codigo ate ser maior que 0 e nao repetido
      repita
         escreva("Digite o codigo: ")
         leia(cod)
         se cod <= 0 entao
            escreval("Codigo invalido, tem que ser maior que 0.")
         senao
            se procurar(cod) <> NAO_ACHOU entao
               escreval("Esse codigo ja existe!")
            fimse
         fimse
      ate (cod > 0) e (procurar(cod) = NAO_ACHOU)

      // Pede titulo e autor
      escreva("Digite o titulo: ")
      leia(tit)
      escreva("Digite o autor: ")
      leia(aut)

      // Pede o ano ate ficar entre ANO_MIN e ANO_MAX
      repita
         escreva("Digite o ano: ")
         leia(ano)
         se (ano < ANO_MIN) ou (ano > ANO_MAX) entao
            escreval("Ano invalido!")
         fimse
      ate (ano >= ANO_MIN) e (ano <= ANO_MAX)

      // Mostra as categorias e pede uma valida (de 1 a MAX_CATEGORIAS)
      para c de 1 ate MAX_CATEGORIAS faca
         escreval(c, " - ", nomeCat[c])
      fimpara
      repita
         escreva("Digite a categoria: ")
         leia(cat)
         se (cat < 1) ou (cat > MAX_CATEGORIAS) entao
            escreval("Categoria nao existe!")
         fimse
      ate (cat >= 1) e (cat <= MAX_CATEGORIAS)

      // Pede a quantidade de exemplares ate ser maior que 0
      repita
         escreva("Quantidade de exemplares: ")
         leia(quant)
         se quant <= 0 entao
            escreval("Quantidade invalida, tem que ser maior que 0.")
         fimse
      ate quant > 0

// Guarda o livro na proxima posicao livre (todos os exemplares comecam disponiveis)
      qtdLivros <- qtdLivros + 1
      livros[qtdLivros].codigo <- cod
      livros[qtdLivros].titulo <- tit
      livros[qtdLivros].autor <- aut
      livros[qtdLivros].ano <- ano
      livros[qtdLivros].categoria <- cat
      livros[qtdLivros].qtdTotal <- quant
      livros[qtdLivros].qtdDisponivel <- quant
      livros[qtdLivros].qtdEmprestimos <- 0
      livros[qtdLivros].status <- DISPONIVEL
      escreval("Livro cadastrado na posicao ", qtdLivros)
   fimse
fimprocedimento

// ---------------- LISTAR E CONSULTAR ----------------

// Lista um resumo de todos os livros cadastrados
procedimento listarAcervo
var i: inteiro
inicio
   se qtdLivros = 0 entao
      escreval("O acervo esta vazio.")
   senao
      para i de 1 ate qtdLivros faca
         escreval(i, " | cod ", livros[i].codigo, " | ", livros[i].titulo, " | ", livros[i].autor, " | disp ", livros[i].qtdDisponivel, " de ", livros[i].qtdTotal)
      fimpara
   fimse
fimprocedimento

// Pede um codigo, procura o livro e mostra os dados dele
procedimento consultarLivro
var cod, posicao: inteiro
inicio
   se qtdLivros = 0 entao
      escreval("Nao tem nenhum livro cadastrado ainda.")
   senao
      escreva("Digite o codigo do livro: ")
      leia(cod)
      posicao <- procurar(cod)
      se posicao = NAO_ACHOU entao
         escreval("Livro nao encontrado.")
      senao
         mostrarLivro(posicao)
      fimse
   fimse
fimprocedimento

// ---------------- EMPRESTIMO E DEVOLUCAO ----------------

// Empresta um exemplar: so se o livro existe, tem exemplar e o status deixa
procedimento realizarEmprestimo
var cod, posicao: inteiro
inicio
   escreva("Digite o codigo do livro: ")
   leia(cod)
   posicao <- procurar(cod)
   se posicao = NAO_ACHOU entao
      escreval("ERRO: esse livro nao existe.")
   senao
      se (livros[posicao].qtdDisponivel > 0) e (livros[posicao].status = DISPONIVEL) entao
         // Tira 1 da estante, conta o emprestimo no livro e na matriz, e atualiza o status
         livros[posicao].qtdDisponivel <- livros[posicao].qtdDisponivel - 1
         livros[posicao].qtdEmprestimos <- livros[posicao].qtdEmprestimos + 1
         mov[livros[posicao].categoria, EMPRESTIMO] <- mov[livros[posicao].categoria, EMPRESTIMO] + 1
         atualizarStatus(posicao)
         escreval("Emprestimo feito! Restam ", livros[posicao].qtdDisponivel, " exemplares.")
      senao
         escreval("ERRO: nao tem exemplar disponivel.")
      fimse
   fimse
fimprocedimento

// Devolve um exemplar: so se tem algum emprestado e se nao passa do total
procedimento realizarDevolucao
var cod, posicao: inteiro
inicio
   escreva("Digite o codigo do livro: ")
   leia(cod)
   posicao <- procurar(cod)
   se posicao = NAO_ACHOU entao
      escreval("ERRO: esse livro nao existe.")
   senao
      se (qtdEmprestada(posicao) > 0) e (livros[posicao].qtdDisponivel < livros[posicao].qtdTotal) entao
         // Devolve 1 para a estante, conta a devolucao na matriz e atualiza o status
         livros[posicao].qtdDisponivel <- livros[posicao].qtdDisponivel + 1
         mov[livros[posicao].categoria, DEVOLUCAO] <- mov[livros[posicao].categoria, DEVOLUCAO] + 1
         atualizarStatus(posicao)
         escreval("Devolucao feita! Disponiveis agora: ", livros[posicao].qtdDisponivel)
      senao
         escreval("ERRO: nenhum exemplar desse livro esta emprestado.")
      fimse
   fimse
fimprocedimento

// Mostra so os livros que tem exemplar na estante e conta quantos sao
procedimento exibirDisponiveis
var i, cont: inteiro
inicio
   cont <- 0
   para i de 1 ate qtdLivros faca
      se livros[i].qtdDisponivel > 0 entao
         escreval(livros[i].codigo, " - ", livros[i].titulo, " (", livros[i].qtdDisponivel, " disponiveis)")
         cont <- cont + 1
      fimse
   fimpara
   se cont = 0 entao
      escreval("Nenhum livro disponivel.")
   fimse
fimprocedimento

// ---------------- ORDENACAO (Bubble Sort) ----------------

// Troca dois livros de lugar levando todos os campos juntos
procedimento trocar(a, b: inteiro)
var cod, ano, cat, total, disp, emp, st: inteiro
    tit, aut: caractere
inicio
   // Guarda o livro A nas variaveis
   cod <- livros[a].codigo
   tit <- livros[a].titulo
   aut <- livros[a].autor
   ano <- livros[a].ano
   cat <- livros[a].categoria
   total <- livros[a].qtdTotal
   disp <- livros[a].qtdDisponivel
   emp <- livros[a].qtdEmprestimos
   st <- livros[a].status
   // Copia o livro B para a posicao A
   livros[a].codigo <- livros[b].codigo
   livros[a].titulo <- livros[b].titulo
   livros[a].autor <- livros[b].autor
   livros[a].ano <- livros[b].ano
   livros[a].categoria <- livros[b].categoria
   livros[a].qtdTotal <- livros[b].qtdTotal
   livros[a].qtdDisponivel <- livros[b].qtdDisponivel
   livros[a].qtdEmprestimos <- livros[b].qtdEmprestimos
   livros[a].status <- livros[b].status
   // Coloca o livro A (guardado) na posicao B
   livros[b].codigo <- cod
   livros[b].titulo <- tit
   livros[b].autor <- aut
   livros[b].ano <- ano
   livros[b].categoria <- cat
   livros[b].qtdTotal <- total
   livros[b].qtdDisponivel <- disp
   livros[b].qtdEmprestimos <- emp
   livros[b].status <- st
fimprocedimento

// Ordena pelo codigo, do menor para o maior (a busca recursiva precisa disso)
procedimento ordenarPorCodigo
var i, j: inteiro
inicio
   para i de 1 ate qtdLivros - 1 faca
      para j de 1 ate qtdLivros - i faca
         se livros[j].codigo > livros[j + 1].codigo entao
            trocar(j, j + 1)
         fimse
      fimpara
   fimpara
fimprocedimento

// Ordena para o ranking: 1° mais emprestimos, 2° menos disponiveis, 3° titulo de A a Z
procedimento ordenarRanking
var i, j: inteiro
    deveTrocar: logico
inicio
   para i de 1 ate qtdLivros - 1 faca
      para j de 1 ate qtdLivros - i faca
         // Decide se o livro j deve trocar com o vizinho, olhando um criterio de cada vez
         deveTrocar <- falso
         se livros[j].qtdEmprestimos < livros[j + 1].qtdEmprestimos entao
            deveTrocar <- verdadeiro
         senao
            se livros[j].qtdEmprestimos = livros[j + 1].qtdEmprestimos entao
               se livros[j].qtdDisponivel > livros[j + 1].qtdDisponivel entao
                  deveTrocar <- verdadeiro
               senao
                  se (livros[j].qtdDisponivel = livros[j + 1].qtdDisponivel) e (livros[j].titulo > livros[j + 1].titulo) entao
                     deveTrocar <- verdadeiro
                  fimse
               fimse
            fimse
         fimse
         se deveTrocar entao
            trocar(j, j + 1)
         fimse
      fimpara
   fimpara
fimprocedimento

// Ordena pelo ranking, mostra a lista e volta o vetor para a ordem de codigo
procedimento exibirRanking
var i: inteiro
inicio
   se qtdLivros = 0 entao
      escreval("O acervo esta vazio.")
   senao
      ordenarRanking
      escreval("POSICAO | LIVRO | AUTOR | EMPRESTIMOS | DISPONIVEIS")
      para i de 1 ate qtdLivros faca
         escreval(i, " | ", livros[i].titulo, " | ", livros[i].autor, " | ", livros[i].qtdEmprestimos, " | ", livros[i].qtdDisponivel)
      fimpara
      ordenarPorCodigo
   fimse
fimprocedimento

// ---------------- MATRIZ E ESTATISTICAS ----------------

// Percorre a matriz mostrando a tabela e soma todas as movimentacoes
procedimento mostrarMatriz
var i, j, total: inteiro
inicio
   total <- 0
   escreval("CATEGORIA | EMPRESTIMOS | DEVOLUCOES")
   para i de 1 ate MAX_CATEGORIAS faca
      escreva(nomeCat[i], " | ")
      para j de 1 ate 2 faca
         escreva(mov[i, j], " | ")
         total <- total + mov[i, j]
      fimpara
      escreval("")
   fimpara
   escreval("Total de movimentacoes: ", total)
fimprocedimento

// Soma exemplares totais e disponiveis; "var" faz os valores voltarem para quem chamou
procedimento somarExemplares(var totalEx, totalDisp: inteiro)
var i: inteiro
inicio
   totalEx <- 0
   totalDisp <- 0
   para i de 1 ate qtdLivros faca
      totalEx <- totalEx + livros[i].qtdTotal
      totalDisp <- totalDisp + livros[i].qtdDisponivel
   fimpara
fimprocedimento

// Calcula e mostra todas as estatisticas do acervo
procedimento exibirEstatisticas
var totalEx, totalDisp, totalEmp, totalDev: inteiro
    i, c, cont, maisEmp, maisDisp, catMais: inteiro
    percDisp, percEmp, media: real
inicio
   se qtdLivros = 0 entao
      escreval("Nao tem livros para mostrar estatisticas.")
   senao
      // Totais de exemplares
      somarExemplares(totalEx, totalDisp)

      // Total de emprestimos e devolucoes, somando a matriz
      totalEmp <- 0
      totalDev <- 0
      para i de 1 ate MAX_CATEGORIAS faca
         totalEmp <- totalEmp + mov[i, EMPRESTIMO]
         totalDev <- totalDev + mov[i, DEVOLUCAO]
      fimpara

      // Percentuais e media
      percDisp <- totalDisp / totalEx * 100
      percEmp <- (totalEx - totalDisp) / totalEx * 100
      media <- totalEx / qtdLivros

      // Acha o livro mais emprestado e o com mais disponiveis (comeca no primeiro e compara com os outros)
      maisEmp <- 1
      maisDisp <- 1
      para i de 2 ate qtdLivros faca
         se livros[i].qtdEmprestimos > livros[maisEmp].qtdEmprestimos entao
            maisEmp <- i
         fimse
         se livros[i].qtdDisponivel > livros[maisDisp].qtdDisponivel entao
            maisDisp <- i
         fimse
      fimpara

      // Mostra os resultados gerais
      escreval("Livros cadastrados: ", qtdLivros)
      escreval("Total de exemplares: ", totalEx)
      escreval("Exemplares disponiveis: ", totalDisp)
      escreval("Exemplares emprestados: ", totalEx - totalDisp)
      escreval("Total de emprestimos: ", totalEmp)
      escreval("Total de devolucoes: ", totalDev)
      escreval("Percentual disponivel: ", percDisp:6:2, "%")
      escreval("Percentual emprestado: ", percEmp:6:2, "%")
      escreval("Media de exemplares por livro: ", media:6:2)
      escreval("Livro mais emprestado: ", livros[maisEmp].titulo)
      escreval("Livro com mais disponiveis: ", livros[maisDisp].titulo)

      // Por categoria: conta os livros, mostra emprestimos e devolucoes e guarda a categoria com mais emprestimos
      escreval("--- Por categoria (livros | emprestimos | devolucoes) ---")
      catMais <- 1
      para c de 1 ate MAX_CATEGORIAS faca
         cont <- 0
         para i de 1 ate qtdLivros faca
            se livros[i].categoria = c entao
               cont <- cont + 1
            fimse
         fimpara
         escreval(nomeCat[c], ": ", cont, " | ", mov[c, EMPRESTIMO], " | ", mov[c, DEVOLUCAO])
         se mov[c, EMPRESTIMO] > mov[catMais, EMPRESTIMO] entao
            catMais <- c
         fimse
      fimpara
      escreval("Categoria com mais emprestimos: ", nomeCat[catMais])
      escreval("")
      mostrarMatriz
   fimse
fimprocedimento

// ---------------- BUSCA RECURSIVA PELO MENU ----------------

// Ordena por codigo, pede o codigo e chama a busca recursiva no vetor todo
procedimento buscaNoCatalogo
var cod, posicao: inteiro
inicio
   se qtdLivros = 0 entao
      escreval("Nao tem livros cadastrados.")
   senao
      ordenarPorCodigo
      escreva("Digite o codigo para buscar: ")
      leia(cod)
      posicao <- buscaRecursiva(cod, 1, qtdLivros)
      se posicao = NAO_ACHOU entao
         escreval("Livro nao encontrado.")
      senao
         escreval("Achei na posicao ", posicao)
         mostrarLivro(posicao)
      fimse
   fimse
fimprocedimento

// ---------------- PROGRAMA PRINCIPAL ----------------
inicio
   comeco
   // Repete o menu ate o usuario escolher 10
   repita
      escreval("")
      escreval("UNILIBRARY - SISTEMA DE GERENCIAMENTO DE BIBLIOTECA")
      escreval("1. Cadastrar livro")
      escreval("2. Listar acervo")
      escreval("3. Consultar livro")
      escreval("4. Realizar emprestimo")
      escreval("5. Realizar devolucao")
      escreval("6. Exibir livros disponiveis")
      escreval("7. Exibir ranking do acervo")
      escreval("8. Exibir estatisticas")
      escreval("9. Realizar busca recursiva")
      escreval("10. Encerrar sistema")
      escreva("Escolha uma opcao: ")
      leia(opcao)
      // Cada opcao chama o procedimento certo; numero invalido cai no outrocaso
      escolha opcao
         caso 1
            cadastrarLivro
         caso 2
            listarAcervo
         caso 3
            consultarLivro
         caso 4
            realizarEmprestimo
         caso 5
            realizarDevolucao
         caso 6
            exibirDisponiveis
         caso 7
            exibirRanking
         caso 8
            exibirEstatisticas
         caso 9
            buscaNoCatalogo
         caso 10
            escreval("Encerrando o sistema...")
         outrocaso
            escreval("Opcao invalida! Digite um numero de 1 a 10.")
      fimescolha
   ate opcao = 10
Fimalgoritmo
