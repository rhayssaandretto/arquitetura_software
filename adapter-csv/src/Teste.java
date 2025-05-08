import java.io.IOException;
import java.util.List;

public class Teste {

    public static void main(String[] args) throws IOException {

        PessoaCSVAdapter adapter = new PessoaCSVAdapter();

        List<Pessoa> pessoas = adapter.listaPessoa("pessoas.csv");
        pessoas.forEach(System.out::println);

    }

}
