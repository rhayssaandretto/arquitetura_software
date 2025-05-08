import java.io.IOException;
import java.util.List;

public interface RepositorioDePessoa {

    List<Pessoa> listaPessoa(String csvFile) throws IOException;

}
