package br.com.fiap.resources;

import java.sql.SQLException;
import java.util.ArrayList;

import javax.ws.rs.Consumes;
import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.UriBuilder;
import javax.ws.rs.core.UriInfo;

import br.com.fiap.model.vo.ClienteVO;
import br.com.fiap.model.bo.ClienteBO;

@Path("/cliente")
public class ClienteResource {
    
    private ClienteBO clienteBO;

    public ClienteResource() {
        try {
            clienteBO = new ClienteBO();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao inicializar ClienteBO: " + e.getMessage());
        }
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    public Response cadastroRs(ClienteVO cliente, @Context UriInfo uriInfo) throws ClassNotFoundException, SQLException {
        if (cliente.getCpfCliente() == null || cliente.getNomeCliente() == null) {
            return Response.status(Response.Status.BAD_REQUEST).entity("CPF e Nome são obrigatórios.").build();
        }

        clienteBO.cadastrarCliente(cliente);
        UriBuilder builder = uriInfo.getAbsolutePathBuilder();
        builder.path(cliente.getCpfCliente());
        return Response.created(builder.build()).build();
    }

    @PUT
    @Path("/{cpfCliente}")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response atualizaRs(ClienteVO cliente, @PathParam("cpfCliente") String cpfCliente) throws ClassNotFoundException, SQLException {
        if (cliente.getNomeCliente() == null) {
            return Response.status(Response.Status.BAD_REQUEST).entity("Nome é obrigatório para atualização.").build();
        }

        try {
            if (!clienteBO.clienteExists(cpfCliente)) {
                return Response.status(Response.Status.NOT_FOUND).entity("Cliente não encontrado.").build();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("Erro ao verificar existência do cliente.").build();
        }

        clienteBO.atualizarCliente(cliente);
        return Response.ok().build();
    }

    @DELETE
    @Path("/{cpfCliente}")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response deletarRs(@PathParam("cpfCliente") String cpfCliente) throws ClassNotFoundException {
        try {
            if (!clienteBO.clienteExists(cpfCliente)) {
                return Response.status(Response.Status.NOT_FOUND).entity("Cliente não encontrado.").build();
            }

            clienteBO.deletarCliente(cpfCliente);
            return Response.ok().build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("Erro ao deletar cliente.").build();
        }
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public ArrayList<ClienteVO> selecionarRs() throws ClassNotFoundException, SQLException {
        return (ArrayList<ClienteVO>) clienteBO.listarClientes();
    }
}
