package br.com.fiap.model.bo;

import br.com.fiap.model.dao.PreDiagnosticoDAO;
import br.com.fiap.model.vo.PreDiagnosticoVO;

import java.sql.SQLException;
import java.util.List;

public class PreDiagnosticoBO {

    private PreDiagnosticoDAO preDiagnosticoDAO;

    public PreDiagnosticoBO() throws ClassNotFoundException, SQLException {
        this.preDiagnosticoDAO = new PreDiagnosticoDAO();
    }

    public String inserir(PreDiagnosticoVO preDiagnostico) {
        try {
            if (preDiagnostico.getID_PreDiagnostico() == null || preDiagnostico.getID_PreDiagnostico().isEmpty()) {
                return "ID do pré-diagnóstico é obrigatório.";
            }
            preDiagnosticoDAO.PreDiagnosticoDAO_inserir(preDiagnostico);
            return "Pré-diagnóstico inserido com sucesso.";
        } catch (SQLException e) {
            e.printStackTrace();
            return "Erro ao inserir pré-diagnóstico: " + e.getMessage();
        }
    }

    public String deletar(String idPreDiagnostico) {
        try {
            if (idPreDiagnostico == null || idPreDiagnostico.isEmpty()) {
                return "ID do pré-diagnóstico é obrigatório.";
            }
            preDiagnosticoDAO.PreDiagnosticoDAO_deletar(idPreDiagnostico);
            return "Pré-diagnóstico deletado com sucesso.";
        } catch (SQLException e) {
            e.printStackTrace();
            return "Erro ao deletar pré-diagnóstico: " + e.getMessage();
        }
    }

    public String atualizar(PreDiagnosticoVO preDiagnostico) {
        try {
            if (preDiagnostico.getID_PreDiagnostico() == null || preDiagnostico.getID_PreDiagnostico().isEmpty()) {
                return "ID do pré-diagnóstico é obrigatório.";
            }
            preDiagnosticoDAO.PreDiagnosticoDAO_atualizar(preDiagnostico);
            return "Pré-diagnóstico atualizado com sucesso.";
        } catch (SQLException e) {
            e.printStackTrace();
            return "Erro ao atualizar pré-diagnóstico: " + e.getMessage();
        }
    }

    public List<PreDiagnosticoVO> selecionarTodos() {
        try {
            return preDiagnosticoDAO.PreDiagnosticoDAO_selecionarTodos();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
