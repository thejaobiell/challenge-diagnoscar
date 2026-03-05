package br.com.fiap.model.dao;

import br.com.fiap.connection.ConnDAO;
import br.com.fiap.model.vo.OficinaVO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OficinaDAO {
    private Connection conexao;

    public OficinaDAO() throws ClassNotFoundException, SQLException {
        this.conexao = new ConnDAO().conexao();
    }

    public void OficinaDAO_inserir(OficinaVO oficina) throws SQLException {
        String sql = "INSERT INTO Oficina (Endereco_Oficina, Cnpj_Oficina, Nome_Oficina, Avaliacao_Oficina, Especializacao_Oficina, Chatbot_ID_Chatbot, Chatbot_Cliente_CPF_Cliente) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, oficina.getEnderecoOficina());
            stmt.setString(2, oficina.getCnpjOficina());
            stmt.setString(3, oficina.getNomeOficina());
            stmt.setDouble(4, oficina.getAvaliacaoOficina());
            stmt.setString(5, oficina.getEspecializacaoOficina());
            stmt.setString(6, oficina.getChatbotIdChatbot());
            stmt.setString(7, oficina.getChatbotClienteCpfCliente());
            stmt.executeUpdate();
        } finally {
            fecharConexao();
        }
    }

    public void OficinaDAO_atualizar(OficinaVO oficina) throws SQLException {
        String sql = "UPDATE Oficina SET Nome_Oficina = ?, Endereco_Oficina = ?, " +
                     "Avaliacao_Oficina = ?, Especializacao_Oficina = ?, " +
                     "Chatbot_ID_Chatbot = ?, Chatbot_Cliente_CPF_Cliente = ? " +
                     "WHERE Cnpj_Oficina = ?";

        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, oficina.getNomeOficina());
            stmt.setString(2, oficina.getEnderecoOficina());
            stmt.setDouble(3, oficina.getAvaliacaoOficina());
            stmt.setString(4, oficina.getEspecializacaoOficina());
            stmt.setString(5, oficina.getChatbotIdChatbot());
            stmt.setString(6, oficina.getChatbotClienteCpfCliente());
            stmt.setString(7, oficina.getCnpjOficina());
            stmt.executeUpdate();
        } finally {
            fecharConexao();
        }
    }

    public void OficinaDAO_deletar(String nomeOficina) throws SQLException {
        String sql = "DELETE FROM Oficina WHERE Nome_Oficina = ?";

        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, nomeOficina);
            stmt.executeUpdate();
        } finally {
            fecharConexao();
        }
    }

    public List<OficinaVO> OficinaDAO_listar() throws SQLException {
        String sql = "SELECT * FROM Oficina";
        List<OficinaVO> oficinas = new ArrayList<>();

        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                OficinaVO oficina = new OficinaVO();
                oficina.setEnderecoOficina(rs.getString("Endereco_Oficina"));
                oficina.setCnpjOficina(rs.getString("Cnpj_Oficina"));
                oficina.setNomeOficina(rs.getString("Nome_Oficina"));
                oficina.setAvaliacaoOficina(rs.getDouble("Avaliacao_Oficina"));
                oficina.setEspecializacaoOficina(rs.getString("Especializacao_Oficina"));
                oficina.setChatbotIdChatbot(rs.getString("Chatbot_ID_Chatbot"));
                oficina.setChatbotClienteCpfCliente(rs.getString("Chatbot_Cliente_CPF_Cliente"));
                oficinas.add(oficina);
            }
        } finally {
            fecharConexao();
        }
        return oficinas;
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
