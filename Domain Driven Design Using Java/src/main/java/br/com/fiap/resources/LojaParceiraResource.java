package br.com.fiap.resources;
 
import java.sql.SQLException;
import java.util.List;
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
 
import br.com.fiap.model.bo.LojaParceiraBO;
import br.com.fiap.model.vo.Loja_ParceiraVO;
 
@Path("/lojasparceiras")
public class LojaParceiraResource {
    private LojaParceiraBO lojaParceiraBO;
 
    public LojaParceiraResource() throws ClassNotFoundException, SQLException {
        lojaParceiraBO = new LojaParceiraBO();
    }
 
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    public Response cadastrarLoja(Loja_ParceiraVO loja, @Context UriInfo uriInfo) throws SQLException {
        try {
            lojaParceiraBO.cadastrarLoja(loja);
            UriBuilder builder = uriInfo.getAbsolutePathBuilder();
            builder.path(loja.getNomeLoja());
            return Response.created(builder.build()).build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.BAD_REQUEST).entity(e.getMessage()).build();
        }
    }
 
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response listarLojas() throws SQLException {
        List<Loja_ParceiraVO> lojas = lojaParceiraBO.listarLojas();
        return Response.ok(lojas).build();
    }
 
    @PUT
    @Path("/{nomeLoja}")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response atualizarLoja(Loja_ParceiraVO loja, @PathParam("nomeLoja") String nomeLoja) throws SQLException {
        try {
            loja.setNomeLoja(nomeLoja);
            lojaParceiraBO.atualizarLoja(loja);
            return Response.ok().build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.BAD_REQUEST).entity(e.getMessage()).build();
        }
    }
 
    @DELETE
    @Path("/{nomeLoja}")
    public Response deletarLoja(@PathParam("nomeLoja") String nomeLoja) throws SQLException {
        try {
            lojaParceiraBO.deletarLoja(nomeLoja);
            return Response.noContent().build();
        } catch (IllegalArgumentException e) {
            return Response.status(Response.Status.BAD_REQUEST).entity(e.getMessage()).build();
        }
    }
}