# Sistema de Gerenciamento de Bibliotecas

## OBS: Clone de um Projeto Public de 2019, original no GitHub de Jay Jagtap (https://github.com/jayjagtap - Library-Management-System-on-Ruby-on-Rails )

<b>CSC517 Outono de 2019 [Projeto 2 (Ruby on Rails)](https://github.com/jayjagtap/Library-Management-System-on-Ruby-on-Rails)</b><br>

<b>Participantes do projeto em 2019</b>

-<b>Docente:</b> [Prof. Edward F. Gehringer](mailto:efg@ncsu.edu)<br> -<b>Mentor:</b> [Akanksha Mohan](mailto:amohan7@ncsu.edu)<br>

-<b>Equipe_469:</b>
[Rohan Pillai](mailto:rspillai@ncsu.edu),
[Omkar Kulkarni](mailto:oskulkar@ncsu.edu),
[Jay Jagtap](mailto:jjjagtap@ncsu.edu)<br>

======================================================================================================

#### Este projeto foi atualizado de/para:

- Ruby '2.6.4' ==> Ruby '3.2.0'<br>
- Ruby on Rails '6.0.0' ==> Ruby on Rails '7.0.4'<br>
- Sqlite3 ==> PostgreSql

#### Passos realizados para a atualização

- Clone do projeto do github para minha maquina
- Exclusão do arquivo gemfile.lock
- Alterar no arquivo gemfile e rubyversion, atualizar versão do ruby (3.2.0) e do rails (7.0.4)
- Executar bundle update
  - Todas as gens foram atualizadas para as ultimas versões para Ruby on Rails 7.0.4.
- Executar bundle check
- Executar rails app:update, e confirme (Y) todas as trocas solicitadas.

===============================================================================================

Após atualizações e o projeto funcionando; comecei analisando a estrutura do projeto, os principais arquivos e diretórios, e a lógica implementada. Estudei os diferentes componentes, serviços e fluxos de dados para compreender como tudo estava integrado.

Com o entendimento básico do projeto, comecei a fazer algumas modificações para adaptar o código às minhas idéias. As modificações incluíram:

- Novas tabelas (Publisher, Nationality, Author, languagem, Subject, Education Level, Telephone, Address)
- Ajustes em tabelas para novos relacionamentos e novos atributos.
- Ajustes em controllers, em função de novas tabelas, novos atributos.
- Ajustes nas views(novos atributos e layout).
- Ajuste em rotas.
- Criação de carga de dados.
- Inclusão de novos validates nos models.
- Inclusão de testes com Rspec (com cobertura de 67%)
- Ajuste em regra de negocio.
  - Uma Universidade pode ter mais de uma biblioteca.
  - Um estudante tera acesso a todos os livros das bibliotecas de sua universidade.
  - Um estudante tera acesso somente de consulta de todos os livros que não saõa das bibliotecas de sua universidade.

======================================================================================================

## Fluxos de Trabalho

Existem 3 tipos diferentes de usuários no aplicativo: Administrador, Bibliotecário e Estudante. Cada um deles tem um link de registro e login separado. As funcionalidades disponíveis para cada usuário estão definidas na seção abaixo.

<b>Recursos Especiais:</b>

1. O Bibliotecário e o Estudante não podem visualizar a conta um do outro nem acessar outras funcionalidades restritas simplesmente alterando a URL.
2. A autenticação via Google foi implementada para o Estudante. (No entanto, essa funcionalidade não está disponível.)

### Adição de um Novo Bibliotecário

Você precisa se registrar usando o link de registro de bibliotecário e, em seguida, aprovar a solicitação de bibliotecário na conta de Administrador.<br>
Para aprovar o bibliotecário, siga as seguintes etapas:

1. Registre-se usando o link de Registro de Bibliotecário.<br>
2. Faça login na conta de Administrador.<br>
3. Vá para Ver Bibliotecário.<br>
4. Clique na opção de edição presente em frente ao bibliotecário que você criou.<br>
5. Altere o valor de aprovado de Não para Sim.<br>

## Detalhes

Existem 5 componentes principais no sistema:

- Biblioteca
- Livro
- Administrador
- Bibliotecário
- Estudante

### Biblioteca

Uma biblioteca tem os seguintes atributos:

- Nome (String)
- Email (String)
- Universidade (String)
- Localização (String)
- Número máximo de dias que um livro pode ser emprestado (Inteiro)
- Multas por atraso para os livros na biblioteca (Número Decimal)

### Livro

Um livro tem os seguintes atributos:

- ISBN (único) (String)
- Título (String)
- Assunto (String)
- Editora(String)
- Autor(es) (String)
- Idioma (String)
- Publicado (Data)
- Edição (String)
- Quantidade (integer)
- Biblioteca Associada (String)
- Imagem da capa frontal (apenas arquivos PNG ou JPEG)
- Assunto do livro (String)
- Resumo (String)
- É um item de Coleção Especial? (Sim/Não) (Booleano)

### Administrador

O sistema possui um administrador pré-configurado com os seguintes atributos:

- Email (único para cada conta) (String)
- Nome (String)
- Identification (String)
- Senha (String)

Um administrador é capaz de realizar todas as operações realizadas por Bibliotecários ou Estudantes, e a conta de administrador não pode ser excluída.
O administrador pode:

- Fazer login com um email e senha
- Editar o perfil
- Criar/Modificar contas de Bibliotecário ou Estudante
- Criar/Modificar/Excluir Bibliotecas e Livros.
- Visualizar a lista de usuários (estudantes e bibliotecários) e seus detalhes de perfil (exceto a senha)
- Visualizar a lista de livros, juntamente com informações detalhadas.
- Visualizar a lista de solicitações de reserva de livros.
- Visualizar a lista de livros emprestados.
- Visualizar a lista de estudantes com livros em atraso (juntamente com multas por atraso).
- Visualizar o histórico de empréstimos de cada livro.
- Excluir Estudante/Livro/Bibliotecário do sistema

### Bibliotecário

Um bibliotecário tem os seguintes atributos:

- Email (único para cada conta) (String)
- Nome (String)
- Senha (String)
- Identification (String)
- Phone (String)
- Password (String)
- Biblioteca (que esta associada)

Qualquer pessoa pode se inscrever como bibliotecário usando seu email, nome e senha. Após o registro, eles devem ser aprovados por um administrador antes de poderem realizar as seguintes tarefas:

- Fazer login com email e senha.
- Editar seu próprio perfil para escolher uma biblioteca existente. Cada bibliotecário pode trabalhar apenas em uma biblioteca.
- Editar os atributos da biblioteca.
- Adicionar/Remover livros na biblioteca.
- Visualizar e Editar informações do livro.
- Visualizar todos os livros.
- Visualizar solicitações de reserva de livros na biblioteca em que trabalham.
- Para livros na coleção especial, aceitar ou recusar solicitações de reserva de livros.
- Visualizar a lista de todos os livros emprestados em sua biblioteca.
- Visualizar o histórico de empréstimos dos livros de sua biblioteca.
- Visualizar a lista de estudantes com livros em atraso em sua biblioteca, juntamente com multas por atraso.

### Estudantes

Um estudante tem os seguintes atributos:

- Email (único para cada conta) (String)
- Nome (String)
- Senha (String)
- Identification (String)
- Phone (String)
- Nível de Educação (Graduação/Pós-Graduação/Estudante de Doutorado)
- Universidade (String)
- Password (String)
- Número máximo de livros (**N**) que podem ser emprestados a qualquer momento (Baseado em seu nível de educação. Graduação - 2, Mestrado - 4, Doutorado - 6). (Inteiro)

Qualquer pessoa pode se inscrever como estudante usando seu email, nome e senha. Após o registro, eles podem realizar as seguintes tarefas:

- Visualizar a lista de todas as bibliotecas
- Editar o perfil para modificar o email, nome e senha apenas.
- Visualizar todos os livros
- Retirar/Requisitar/Devolver um livro de qualquer biblioteca associada à sua universidade.
- Excluir uma solicitação de reserva que ainda não foi aprovada (pendente).
- Visualizar/Editar os atributos de sua conta (incluindo a alteração de senha).
- Pesquisar por livros
  - Pesquisar por título
  - Pesquisar por autor
  - Pesquisar por data de publicação
  - Pesquisar por assunto
- Marcar um livro de seu interesse.
- Visualizar seus livros marcados.
- A qualquer momento, um estudante pode emprestar no máximo '**N**' livros com base em seu nível de educação.
- Visualizar as multas por atraso de sua conta.

- Receber um email quando qualquer uma de suas solicitações de livro for bem-sucedida.

#### Solicitação de Reserva de Livro

- Se o livro estiver disponível, prossiga para o empréstimo:
  - Se o livro estiver na lista de Coleção Especial, adicione-o à lista de aprovação do Bibliotecário e aguarde.
  - Caso contrário, adicione o livro à lista de livros retirados pelo estudante.
- Se o livro estiver indisponível ou o estudante já tiver retirado **N** livros,

  - Informe o estudante de que o livro está indisponível ou que o limite máximo foi atingido.
  - Crie uma solicitação de reserva de livro se o estudante desejar continuar solicitando.

- O número de solicitações de reserva de um livro é visível para todos os usuários.

#### Devolução de um Livro

- Se não houver solicitação de reserva para um livro, devolva-o e aumente a contagem disponível do livro.
- Se houver uma solicitação de reserva pendente,
  - Aprovar a solicitação de reserva e adicionar o livro à lista de livros retirados pelo estudante solicitante.
  - Envie um email ao estudante informando que o livro foi retirado.

## Algumas Views

. Welcome
<img src="public/images/pagina principal.jpeg" alt="pagina principal">

. Painel Admin
<img src="public/images/painel admin.jpeg" alt="painel admin">

. List University admin
<img src="public/images/list university admin.jpeg" alt="list university admin">

. List Library admin
<img src="public/images/list library admin.jpeg" alt="list library admin">

. Kist Librarian admin
<img src="public/images/list librarian admin.jpeg" alt="list librarian admin">

. List Students admin
<img src="public/images/list student admin.jpeg" alt="list student admin">

. New Library admin
<img src="public/images/new library admin.jpeg" alt="new library admin">

. Painel Librarian
<img src="public/images/painel librarian.jpeg" alt="painel librarian">

. List book librarian
<img src="public/images/list book librarian.jpeg" alt="list book librarian">

. Overdue Book librarian
<img src="public/images/overdue book librarian.jpeg" alt="overdue book librarian">

. Special Book librarian
<img src="public/images/special book librarian.jpeg" alt="special book librarian">

. Painel Student
<img src="public/images/painel student.jpeg" alt="painel student">

. List Books student
<img src="public/images/list books student.jpeg" alt="list books student">

. Situation Books student
<img src="public/images/situation books student.jpeg" alt="situation books student">

. Overdue Book student
<img src="public/images/overdue book student.jpeg" alt="overdue book student">

## Como iniciar o projeto

Para executar esse projeto você deve ter um computador, preferencialmente com
Linux, com a linguagem de programação Ruby na versão 3.2.0.

Dentro do diretório do projeto, você deve instalar as dependências definidas no
arquivo `Gemfile` com o comando `bundle install`.

Criação da base de dados

- ATENÇÃO : Estou usando a gem figaro (semelhante a gem dotenv-rails), então e necessarios fazer os devidos ajustes (antes do "rails db:create") no arquivo app/config/database.yml, de acordo com suas credenciais para o banco de daos Postgresql.
- rails db:create
- rails db:migrate
- rails db:seed (cria a base de dados com informações)
  OBS: Caso não queira popular a base dados, NÃO executar "rails db:seed",
  - rails c
  - É obrigatorio a criação do administrador.
    - User.create(name: 'Nome do administrador', email: 'admin@email.com', password: '12345678')
      - A senha tem que ter no minimo 8 caracters.

Com todas dependências instaladas, execute `rails server` e acesse
`localhost:3000` em seu navegador.

Login com

- email => admin@email.com password => 12345678

## Executando os testes

Com todas dependências instaladas, como descrito na seção anterior, em seu
terminal execute

- `bundle exec rspec`.
