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

import br.com.fiap.model.vo.AutomovelVO;
import br.com.fiap.model.bo.AutomovelBO;

@Path("/automovel")
public class AutomovelResource {
    
    private AutomovelBO automovelBO;

    public AutomovelResource() {
        try {
            automovelBO = new AutomovelBO();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao inicializar AutomovelBO: " + e.getMessage());
        }
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    public Response cadastrarAutomovel(AutomovelVO automovel, @Context UriInfo uriInfo) throws ClassNotFoundException, SQLException {
        if (automovel.getPlacaAutomovel() == null || automovel.getMarcaAutomovel() == null || automovel.getModeloAutomovel() == null) {
            return Response.status(Response.Status.BAD_REQUEST).entity("Placa, Marca e Modelo são obrigatórios.").build();
        }

        automovelBO.cadastrarAutomovel(automovel);
        UriBuilder builder = uriInfo.getAbsolutePathBuilder();
        builder.path(automovel.getPlacaAutomovel());
        return Response.created(builder.build()).build();
    }

    @PUT
    @Path("/{placaAutomovel}")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response atualizarAutomovel(AutomovelVO automovel, @PathParam("placaAutomovel") String placaAutomovel) throws ClassNotFoundException, SQLException {
        if (automovel.getMarcaAutomovel() == null || automovel.getModeloAutomovel() == null) {
            return Response.status(Response.Status.BAD_REQUEST).entity("Marca e Modelo são obrigatórios para atualização.").build();
        }

        try {
            if (!automovelBO.automovelExiste(placaAutomovel)) {
                return Response.status(Response.Status.NOT_FOUND).entity("Automóvel não encontrado.").build();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("Erro ao verificar existência do automóvel.").build();
        }

        automovelBO.atualizarAutomovel(automovel);
        return Response.ok().build();
    }

    @DELETE
    @Path("/{placaAutomovel}")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response deletarAutomovel(@PathParam("placaAutomovel") String placaAutomovel) throws ClassNotFoundException {
        try {
            if (!automovelBO.automovelExiste(placaAutomovel)) {
                return Response.status(Response.Status.NOT_FOUND).entity("Automóvel não encontrado.").build();
            }

            automovelBO.deletarAutomovel(placaAutomovel);
            return Response.ok().build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR).entity("Erro ao deletar automóvel.").build();
        }
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public ArrayList<AutomovelVO> listarAutomoveis() throws ClassNotFoundException, SQLException {
        return (ArrayList<AutomovelVO>) automovelBO.listarAutomoveis();
    }
}
