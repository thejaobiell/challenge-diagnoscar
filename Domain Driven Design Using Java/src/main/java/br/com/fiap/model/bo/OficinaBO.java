package br.com.fiap.model.bo;

import br.com.fiap.model.dao.OficinaDAO;
import br.com.fiap.model.vo.OficinaVO;

import java.sql.SQLException;
import java.util.List;

public class OficinaBO {
    private OficinaDAO oficinaDAO;

    public OficinaBO() throws ClassNotFoundException, SQLException {
        this.oficinaDAO = new OficinaDAO();
    }

    public void cadastrarOficina(OficinaVO oficina) throws SQLException {
        if (oficina.getCnpjOficina() == null || oficina.getCnpjOficina().trim().isEmpty()) {
            throw new IllegalArgumentException("CNPJ da oficina não pode estar vazio");
        }

        if (oficina.getNomeOficina() == null || oficina.getNomeOficina().trim().isEmpty()) {
            throw new IllegalArgumentException("Nome da oficina não pode estar vazio");
        }

        if (oficina.getAvaliacaoOficina() != null && 
            (oficina.getAvaliacaoOficina() < 0 || oficina.getAvaliacaoOficina() > 10)) {
            throw new IllegalArgumentException("Avaliação deve estar entre 0 e 10");
        }

        oficinaDAO.OficinaDAO_inserir(oficina);
    }

    public void atualizarOficina(OficinaVO oficina) throws SQLException {
        if (oficina.getCnpjOficina() == null || oficina.getCnpjOficina().trim().isEmpty()) {
            throw new IllegalArgumentException("CNPJ da oficina não pode estar vazio");
        }

        oficinaDAO.OficinaDAO_atualizar(oficina);
    }

    public void deletarOficina(String cnpjOficina) throws SQLException {
        if (cnpjOficina == null || cnpjOficina.trim().isEmpty()) {
            throw new IllegalArgumentException("CNPJ não pode estar vazio");
        }

        oficinaDAO.OficinaDAO_deletar(cnpjOficina);
    }

    public List<OficinaVO> listarOficinas() throws SQLException {
        return oficinaDAO.OficinaDAO_listar();
    }
}
