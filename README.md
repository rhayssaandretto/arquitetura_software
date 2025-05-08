# EXPLICAÇÃO:

1. CLASSE `Pessoa`

### 👉 Função:
Representar os dados que serão manipulados. Ela não faz parte de nenhum padrão em si, mas é usada por ambos.

2. CLASSE `PessoaCSVAdapter`

### 👉 Função:
Adaptar o formato externo (CSV) para o formato interno (objetos Pessoa).
Isso permite que o resto do sistema continue funcionando sem saber a origem dos dados.

3. INTERFACE `RepositorioDePessoa`

### 👉 Função:
Fornecer uma interface de acesso aos dados da Pessoa, desacoplando a lógica de negócios do armazenamento em si.

4. CLASSE `Teste`

### 👉 Função:
Verifica se os dados de um CSV são convertidos corretamente em objetos Pessoa.


## INTEGRANTES
Rhayssa Justino Andretto RA: 211631272
Yves Morello RA: 220140552
