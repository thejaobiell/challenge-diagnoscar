package br.com.fiap.model.bo;

import java.sql.SQLException;
import java.util.List;

import br.com.fiap.model.dao.LojaParceiraDAO;
import br.com.fiap.model.vo.Loja_ParceiraVO;

public class LojaParceiraBO {
    private LojaParceiraDAO lojaParceiraDAO;

    public LojaParceiraBO() throws ClassNotFoundException, SQLException {
        lojaParceiraDAO = new LojaParceiraDAO();
    }

    public void cadastrarLoja(Loja_ParceiraVO loja) throws SQLException {
        if (loja.getCnpjLoja() == null || loja.getCnpjLoja().trim().isEmpty()) {
            throw new IllegalArgumentException("CNPJ da loja não pode estar vazio");
        }

        if (loja.getNomeLoja() == null || loja.getNomeLoja().trim().isEmpty()) {
            throw new IllegalArgumentException("Nome da loja não pode estar vazio");
        }

        if (loja.getAvaliacaoLoja() < 0 || loja.getAvaliacaoLoja() > 10) {
            throw new IllegalArgumentException("Avaliação deve estar entre 0 e 10");
        }

        lojaParceiraDAO.LojaParceiraDAO_Inserir(loja);
    }

    public void atualizarLoja(Loja_ParceiraVO loja) throws SQLException {
        if (loja.getCnpjLoja() == null || loja.getCnpjLoja().trim().isEmpty()) {
            throw new IllegalArgumentException("CNPJ da loja não pode estar vazio");
        }

        lojaParceiraDAO.LojaParceiraDAO_Atualizar(loja);
    }

    public void deletarLoja(String cnpjLoja) throws SQLException {
        if (cnpjLoja == null || cnpjLoja.trim().isEmpty()) {
            throw new IllegalArgumentException("CNPJ não pode estar vazio");
        }

        lojaParceiraDAO.LojaParceiraDAO_Deletar(cnpjLoja);
    }

    public List<Loja_ParceiraVO> listarLojas() throws SQLException {
        return lojaParceiraDAO.LojaParceiraDAO_Selecionar();
    }
}