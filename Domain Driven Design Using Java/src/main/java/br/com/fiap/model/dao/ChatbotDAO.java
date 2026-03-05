package br.com.fiap.model.dao;

import br.com.fiap.model.vo.ChatbotVO;
import br.com.fiap.connection.ConnDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ChatbotDAO {

    private Connection conexao;

    public ChatbotDAO() throws ClassNotFoundException, SQLException {
        this.conexao = new ConnDAO().conexao();
    }

    // Método para fechar a conexão
    private void fecharConexao() {
        if (conexao != null) {
            try {
                conexao.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Inserir
    public String ChatbotDAO_inserir(ChatbotVO chatbot) throws SQLException {
        String sql = "INSERT INTO Chatbot (ID_Chatbot, Data_Chat, Plano, Cliente_CPF_Cliente, Placa_Automovel) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, chatbot.getIdChatbot());
            stmt.setDate(2, new java.sql.Date(chatbot.getDataChat().getTime())); // Usando apenas Date
            stmt.setString(3, chatbot.getPlano());
            stmt.setString(4, chatbot.getCpfClienteCpf());
            stmt.setString(5, chatbot.getPlacaAutomovel());
            stmt.executeUpdate();
        } finally {
            fecharConexao();
        }
        return "Chatbot cadastrado com sucesso!";
    }
    
    // Deletar
    public String ChatbotDAO_deletar(String idChatbot, String cpfCliente) throws SQLException {
        System.out.println("Tentando deletar chatbot com ID: " + idChatbot + " e CPF: " + cpfCliente);
        String sql = "DELETE FROM Chatbot WHERE ID_Chatbot = ? AND Cliente_CPF_Cliente = ?";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, idChatbot);
            stmt.setString(2, cpfCliente);
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Nenhum chatbot encontrado com ID " + idChatbot + " e CPF " + cpfCliente);
            }
        } finally {
            fecharConexao();
        }
        return "Chatbot deletado com sucesso!";
    }

    // Atualizar
    public String ChatbotDAO_atualizar(ChatbotVO chatbot) throws SQLException {
        String sql = "UPDATE Chatbot SET Data_Chat = ?, Plano = ?, Cliente_CPF_Cliente = ?, Placa_Automovel = ? WHERE ID_Chatbot = ?";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setDate(1, new java.sql.Date(chatbot.getDataChat().getTime())); // Usando apenas Date
            stmt.setString(2, chatbot.getPlano());
            stmt.setString(3, chatbot.getCpfClienteCpf());
            stmt.setString(4, chatbot.getPlacaAutomovel());
            stmt.setString(5, chatbot.getIdChatbot());
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Nenhum chatbot encontrado com ID " + chatbot.getIdChatbot());
            }
        } finally {
            fecharConexao();
        }
        return "Chatbot atualizado com sucesso!";
    }

    // Selecionar
    public List<ChatbotVO> ChatbotDAO_selecionar() throws SQLException {
        List<ChatbotVO> listaChatbot = new ArrayList<>();
        String sql = "SELECT * FROM Chatbot";
        
        try (PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
             
            while (rs.next()) {
                ChatbotVO chatbot = new ChatbotVO(
                    rs.getString("ID_Chatbot"),
                    rs.getDate("Data_Chat"),
                    rs.getString("Plano"),
                    rs.getString("Cliente_CPF_Cliente"),
                    rs.getString("Placa_Automovel")
                );
                listaChatbot.add(chatbot);
            }
        } finally {
            fecharConexao();
        }
        return listaChatbot;
    }
}
