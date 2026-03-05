package br.com.fiap.model.dao;

import br.com.fiap.model.vo.Loja_ParceiraVO;
import br.com.fiap.connection.ConnDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class LojaParceiraDAO {

    private Connection conexao;

    public LojaParceiraDAO() throws ClassNotFoundException, SQLException {
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
    public String LojaParceiraDAO_Inserir(Loja_ParceiraVO loja) throws SQLException {
        String sql = "INSERT INTO Loja_Parceira (ENDERECO_LOJA, CNPJ_LOJA, NOME_LOJA, AVALIACAO_LOJA, ESPECIALIZACAO_LOJA) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, loja.getEnderecoLoja());
            stmt.setString(2, loja.getCnpjLoja());
            stmt.setString(3, loja.getNomeLoja());
            stmt.setDouble(4, loja.getAvaliacaoLoja());
            stmt.setString(5, loja.getEspecializacaoLoja());
            stmt.executeUpdate();
        } finally {
            fecharConexao();
        }
        return "Loja parceira cadastrada com sucesso!";
    }

    // Deletar
    public String LojaParceiraDAO_Deletar(String cnpjLoja) throws SQLException {
        String sql = "DELETE FROM Loja_Parceira WHERE CNPJ_LOJA = ?";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, cnpjLoja);
            stmt.executeUpdate();
        } finally {
            fecharConexao();
        }
        return "Loja parceira deletada com sucesso!";
    }

    // Atualizar
    public String LojaParceiraDAO_Atualizar(Loja_ParceiraVO loja) throws SQLException {
        String sql = "UPDATE Loja_Parceira SET ENDERECO_LOJA = ?, NOME_LOJA = ?, AVALIACAO_LOJA = ?, ESPECIALIZACAO_LOJA = ? WHERE CNPJ_LOJA = ?";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, loja.getEnderecoLoja());
            stmt.setString(2, loja.getNomeLoja());
            stmt.setDouble(3, loja.getAvaliacaoLoja());
            stmt.setString(4, loja.getEspecializacaoLoja());
            stmt.setString(5, loja.getCnpjLoja());
            stmt.executeUpdate();
        } finally {
            fecharConexao();
        }
        return "Loja parceira atualizada com sucesso!";
    }

    // Selecionar
    public List<Loja_ParceiraVO> LojaParceiraDAO_Selecionar() throws SQLException {
        List<Loja_ParceiraVO> listaLojas = new ArrayList<>();
        String sql = "SELECT * FROM Loja_Parceira";
        
        try (PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
             
            while (rs.next()) {
                Loja_ParceiraVO loja = new Loja_ParceiraVO(
                    rs.getString("Endereco_Loja"),
                    rs.getString("Cnpj_Loja"),
                    rs.getString("Nome_Loja"),
                    rs.getDouble("Avaliacao_Loja"),
                    rs.getString("Especializacao_Loja")
                );
                listaLojas.add(loja);
            }
        } finally {
            fecharConexao();
        }
        return listaLojas;
    }
}
