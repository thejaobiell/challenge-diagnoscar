package br.com.fiap.model.bo;

import java.sql.SQLException;
import java.util.ArrayList;

import br.com.fiap.model.vo.ClienteVO;
import br.com.fiap.model.dao.ClienteDAO;

public class ClienteBO {
    ClienteDAO clienteDAO;

    public ClienteBO() throws ClassNotFoundException, SQLException {
        this.clienteDAO = new ClienteDAO();
    }

    public void cadastrarCliente(ClienteVO cliente) throws ClassNotFoundException, SQLException {
        clienteDAO.ClienteDAO_Inserir(cliente);
    }

    public void atualizarCliente(ClienteVO cliente) throws ClassNotFoundException, SQLException {
        clienteDAO.ClienteDAO_Atualizar(cliente);
    }

    public void deletarCliente(String cpfCliente) throws ClassNotFoundException, SQLException {
        clienteDAO.ClienteDAO_Deletar(cpfCliente);
    }

    public ArrayList<ClienteVO> listarClientes() throws ClassNotFoundException, SQLException {
        return (ArrayList<ClienteVO>) clienteDAO.ClienteDAO_Selecionar();
    }
    
    public boolean clienteExists(String cpfCliente) throws SQLException {
        return clienteDAO.clienteExiste(cpfCliente);
    }
}
