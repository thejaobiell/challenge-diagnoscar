package br.com.fiap.model.dao;

import br.com.fiap.model.vo.PecaVO;
import br.com.fiap.connection.ConnDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PecaDAO {

    private Connection conexao;

    public PecaDAO() throws ClassNotFoundException, SQLException {
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
    public String PecaDAO_Inserir(PecaVO peca) throws SQLException {
        String sql = "INSERT INTO PECA (ID_PECA, TIPO_PECA, NOME_PECA, DESCRICAO_PECA, LOJA_PARCEIRA_ENDERECO) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, peca.getIdPeca());
            stmt.setString(2, peca.getTipoPeca());
            stmt.setString(3, peca.getNomePeca());
            stmt.setString(4, peca.getDescricaoPeca());
            stmt.setString(5, peca.getLojaParceiraEndereco());
            stmt.executeUpdate();
        } finally {
            fecharConexao();
        }
        return "Peça cadastrada com sucesso!";
    }

    // Deletar
    public String PecaDAO_Deletar(String idPeca) throws SQLException {
        String sql = "DELETE FROM PECA WHERE ID_PECA = ?";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, idPeca);
            stmt.executeUpdate();
        } finally {
            fecharConexao();
        }
        return "Peça deletada com sucesso!";
    }

    // Atualizar
    public String PecaDAO_Atualizar(PecaVO peca) throws SQLException {
        String sql = "UPDATE PECA SET TIPO_PECA = ?, NOME_PECA = ?, DESCRICAO_PECA = ?, LOJA_PARCEIRA_ENDERECO = ? WHERE ID_PECA = ?";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, peca.getTipoPeca());
            stmt.setString(2, peca.getNomePeca());
            stmt.setString(3, peca.getDescricaoPeca());
            stmt.setString(4, peca.getLojaParceiraEndereco());
            stmt.setString(5, peca.getIdPeca());
            stmt.executeUpdate();
        } finally {
            fecharConexao();
        }
        return "Peça atualizada com sucesso!";
    }

    // Selecionar
    public List<PecaVO> PecaDAO_Selecionar() throws SQLException {
        List<PecaVO> listaPecas = new ArrayList<>();
        String sql = "SELECT * FROM PECA";
        
        try (PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
             
            while (rs.next()) {
                PecaVO peca = new PecaVO(
                    rs.getString("ID_PECA"),
                    rs.getString("TIPO_PECA"),
                    rs.getString("NOME_PECA"),
                    rs.getString("DESCRICAO_PECA"),
                    rs.getString("LOJA_PARCEIRA_ENDERECO")
                );
                listaPecas.add(peca);
            }
        } finally {
            fecharConexao();
        }
        return listaPecas;
    }
}
