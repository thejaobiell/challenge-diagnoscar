package br.com.fiap.model.bo;

import java.sql.SQLException;
import java.util.ArrayList;

import br.com.fiap.model.vo.AutomovelVO;
import br.com.fiap.model.dao.AutomovelDAO;

public class AutomovelBO {
    private AutomovelDAO automovelDAO;

    public AutomovelBO() throws ClassNotFoundException, SQLException {
        this.automovelDAO = new AutomovelDAO();
    }

    public void cadastrarAutomovel(AutomovelVO automovel) throws ClassNotFoundException, SQLException {
        automovelDAO.AutomovelDAO_Inserir(automovel);
    }

    public void atualizarAutomovel(AutomovelVO automovel) throws ClassNotFoundException, SQLException {
        automovelDAO.AutomovelDAO_Atualizar(automovel);
    }

    public void deletarAutomovel(String placaAutomovel) throws ClassNotFoundException, SQLException {
        automovelDAO.AutomovelDAO_Deletar(placaAutomovel);
    }

    public ArrayList<AutomovelVO> listarAutomoveis() throws ClassNotFoundException, SQLException {
        return (ArrayList<AutomovelVO>) automovelDAO.AutomovelDAO_Selecionar();
    }

    public boolean automovelExiste(String placaAutomovel) throws SQLException {
        return automovelDAO.automovelExiste(placaAutomovel);
    }
}
