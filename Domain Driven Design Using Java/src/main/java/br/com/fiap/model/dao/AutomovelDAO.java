package br.com.fiap.model.dao;

import br.com.fiap.model.vo.AutomovelVO;
import br.com.fiap.connection.ConnDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AutomovelDAO {

    private Connection conexao;

    public AutomovelDAO() throws ClassNotFoundException, SQLException {
        this.conexao = new ConnDAO().conexao();
    }

    public String AutomovelDAO_Inserir(AutomovelVO automovel) throws SQLException {
        String sql = "INSERT INTO Automovel (PLACA_AUTOMOVEL, MARCA_AUTOMOVEL, MODELO_AUTOMOVEL, ANO_AUTOMOVEL, Cliente_CPF_Cliente) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, automovel.getPlacaAutomovel());
            stmt.setString(2, automovel.getMarcaAutomovel());
            stmt.setString(3, automovel.getModeloAutomovel());
            stmt.setInt(4, automovel.getAnoAutomovel());
            stmt.setString(5, automovel.getClienteCpfCliente());
            stmt.executeUpdate();
        }
        return "Automóvel cadastrado com sucesso!";
    }

    public String AutomovelDAO_Deletar(String placaAutomovel) throws SQLException {
        String sql = "DELETE FROM Automovel WHERE PLACA_AUTOMOVEL = ?";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, placaAutomovel);
            stmt.executeUpdate();
        }
        return "Automóvel deletado com sucesso!";
    }

    public String AutomovelDAO_Atualizar(AutomovelVO automovel) throws SQLException {
        String sql = "UPDATE Automovel SET MARCA_AUTOMOVEL = ?, MODELO_AUTOMOVEL = ?, ANO_AUTOMOVEL = ?, Cliente_CPF_Cliente = ? WHERE PLACA_AUTOMOVEL = ?";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, automovel.getMarcaAutomovel());
            stmt.setString(2, automovel.getModeloAutomovel());
            stmt.setInt(3, automovel.getAnoAutomovel());
            stmt.setString(4, automovel.getClienteCpfCliente());
            stmt.setString(5, automovel.getPlacaAutomovel());
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("Nenhum registro foi atualizado, verifique a placa fornecida.");
            }
        }
        return "Automóvel atualizado com sucesso!";
    }


    public List<AutomovelVO> AutomovelDAO_Selecionar() throws SQLException {
        List<AutomovelVO> listaAutomovel = new ArrayList<>();
        String sql = "SELECT * FROM Automovel";
        try (PreparedStatement stmt = conexao.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                AutomovelVO automovel = new AutomovelVO(
                    rs.getString("PLACA_AUTOMOVEL"),
                    rs.getString("MARCA_AUTOMOVEL"),
                    rs.getString("MODELO_AUTOMOVEL"),
                    rs.getInt("ANO_AUTOMOVEL"),
                    rs.getString("Cliente_CPF_Cliente")
                );
                listaAutomovel.add(automovel);
            }
        }
        return listaAutomovel;
    }

    public boolean automovelExiste(String placaAutomovel) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Automovel WHERE PLACA_AUTOMOVEL = ?";
        try (PreparedStatement stmt = conexao.prepareStatement(sql)) {
            stmt.setString(1, placaAutomovel);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }
}
