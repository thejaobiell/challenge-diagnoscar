package br.com.fiap.model.dao;

import br.com.fiap.model.vo.TabelaAssociativaVO;
import br.com.fiap.connection.ConnDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TabelaAssociativaDAO {
	
	private Connection conexao;

    public TabelaAssociativaDAO() throws ClassNotFoundException, SQLException {
        super();
        this.conexao = new ConnDAO().conexao();
    }

    public void TabelaAssociativa_Inserir(TabelaAssociativaVO tabelaAssociativa) throws SQLException {
        String sql = "INSERT INTO Tabela_de_Associacao (CPF_Cliente, ID_Chatbot, Endereco_Loja) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, tabelaAssociativa.getCpfCliente());
            stmt.setString(2, tabelaAssociativa.getIdChatbot());
            stmt.setString(3, tabelaAssociativa.getEnderecoLoja());
            stmt.executeUpdate();
        }
    }

    public TabelaAssociativaVO TabelaAssociativa_Selecionar(String cpfCliente, String idChatbot) throws SQLException {
        String sql = "SELECT * FROM Tabela_de_Associacao WHERE CPF_Cliente = ? AND ID_Chatbot = ?";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, cpfCliente);
            stmt.setString(2, idChatbot);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new TabelaAssociativaVO(
                    rs.getString("CPF_Cliente"),
                    rs.getString("ID_Chatbot"),
                    rs.getString("Endereco_Loja")
                );
            }
            return null;
        }
    }

    public void TabelaAssociativa_Atualizar(TabelaAssociativaVO tabelaAssociativa) throws SQLException {
        String sql = "UPDATE Tabela_de_Associacao SET Endereco_Loja = ? WHERE CPF_Cliente = ? AND ID_Chatbot = ?";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, tabelaAssociativa.getEnderecoLoja());
            stmt.setString(2, tabelaAssociativa.getCpfCliente());
            stmt.setString(3, tabelaAssociativa.getIdChatbot());
            stmt.executeUpdate();
        }
    }

    public void TabelaAssociativa_Deletar(String cpfCliente, String idChatbot) throws SQLException {
        String sql = "DELETE FROM Tabela_de_Associacao WHERE CPF_Cliente = ? AND ID_Chatbot = ?";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, cpfCliente);
            stmt.setString(2, idChatbot);
            stmt.executeUpdate();
        }
    }
}
