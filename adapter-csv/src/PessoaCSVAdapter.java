import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class PessoaCSVAdapter implements RepositorioDePessoa{

    @Override
    public List<Pessoa> listaPessoa(String csvFile) throws IOException {
        List<Pessoa> pessoas = new ArrayList<>();

        BufferedReader reader = new BufferedReader(new FileReader(csvFile));

        boolean cabecalho = true;
        String linha;

        while (Objects.nonNull(linha = reader.readLine())){
            if(cabecalho){
                cabecalho = false;
                continue;
            }
            String[] valores = linha.split(",");

            Pessoa pessoa = new Pessoa(valores[0], Integer.parseInt(valores[1]), valores[2]);
            pessoas.add(pessoa);
        }
        return pessoas;
    }
}
