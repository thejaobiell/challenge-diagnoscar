package br.com.fiap.model.dao;

import br.com.fiap.model.vo.PreDiagnosticoVO;
import br.com.fiap.connection.ConnDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PreDiagnosticoDAO {

    private Connection conexao;

    public PreDiagnosticoDAO() throws ClassNotFoundException, SQLException {
        this.conexao = new ConnDAO().conexao();
    }

    public void PreDiagnosticoDAO_inserir(PreDiagnosticoVO preDiagnostico) throws SQLException {
        String sql = "INSERT INTO Pre_Diagnostico (ID_PreDiagnostico, Nivel_Diagnostico, Diagnostico, Assistente_ID_Chatbot, Cliente_CPF_Cliente, Placa_Automovel) VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, preDiagnostico.getID_PreDiagnostico());
            stmt.setInt(2, preDiagnostico.getNivel_Diagnostico());
            stmt.setString(3, preDiagnostico.getDiagnostico());
            stmt.setString(4, preDiagnostico.getAssistente_ID_Chatbot());
            stmt.setString(5, preDiagnostico.getCliente_CPF_Cliente());
            stmt.setString(6, preDiagnostico.getPlaca_Automovel());
            stmt.executeUpdate();
        }
    }


    public List<PreDiagnosticoVO> PreDiagnosticoDAO_selecionarTodos() throws SQLException {
        String sql = "SELECT * FROM Pre_Diagnostico";
        List<PreDiagnosticoVO> preDiagnosticos = new ArrayList<>();

        try (PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
            	PreDiagnosticoVO preDiagnostico = new PreDiagnosticoVO(
                        rs.getString("ID_PreDiagnostico"),
                        rs.getInt("Nivel_Diagnostico"),
                        rs.getString("Diagnostico"),
                        rs.getString("Assistente_ID_Chatbot"),
                        rs.getString("Cliente_CPF_Cliente"),
                        rs.getString("Placa_Automovel")
                );
                preDiagnosticos.add(preDiagnostico);
            }
        }
        return preDiagnosticos;
    }

    public void PreDiagnosticoDAO_atualizar(PreDiagnosticoVO preDiagnostico) throws SQLException {
        String sql = "UPDATE Pre_Diagnostico SET Nivel_Diagnostico = ?, Diagnostico = ?, Assistente_ID_Chatbot = ?, Cliente_CPF_Cliente = ?, Placa_Automovel = ?, WHERE ID_PreDiagnostico = ?";

        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setInt(1, preDiagnostico.getNivel_Diagnostico());
            stmt.setString(2, preDiagnostico.getDiagnostico());
            stmt.setString(3, preDiagnostico.getAssistente_ID_Chatbot());
            stmt.setString(4, preDiagnostico.getCliente_CPF_Cliente());
            stmt.setString(5, preDiagnostico.getPlaca_Automovel());
            stmt.setString(6, preDiagnostico.getID_PreDiagnostico());
            stmt.executeUpdate();
        }
    }

    public void PreDiagnosticoDAO_deletar(String idPreDiagnostico) throws SQLException {
        String sql = "DELETE FROM Pre_Diagnostico WHERE ID_PreDiagnostico = ?";

        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, idPreDiagnostico);
            stmt.executeUpdate();
        }
    }

    private void fecharConexao() {
        if (conexao != null) {
            try {
                conexao.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
