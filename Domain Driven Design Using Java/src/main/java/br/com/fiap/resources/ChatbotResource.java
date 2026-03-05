package br.com.fiap.resources;

import br.com.fiap.model.bo.ChatbotBO;
import br.com.fiap.model.vo.ChatbotVO;

import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.UriBuilder;
import javax.ws.rs.core.UriInfo;
import java.sql.SQLException;
import java.util.List;

@Path("/chatbot")
public class ChatbotResource {

    private ChatbotBO chatbotBO;

    public ChatbotResource() {
        try {
            chatbotBO = new ChatbotBO();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Erro ao inicializar ChatbotBO: " + e.getMessage());
        }
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    public Response cadastrarChatbot(ChatbotVO chatbot, @Context UriInfo uriInfo) throws SQLException {
        String mensagem = chatbotBO.cadastrarChatbot(chatbot);
        UriBuilder builder = uriInfo.getAbsolutePathBuilder();
        builder.path(chatbot.getIdChatbot());
        return Response.created(builder.build()).entity(mensagem).build();
    }

    @PUT
    @Path("/{idChatbot}")
    @Consumes(MediaType.APPLICATION_JSON)
    public Response atualizarChatbot(ChatbotVO chatbot, @PathParam("idChatbot") String idChatbot) {
        try {
            chatbot.setIdChatbot(idChatbot);
            String mensagem = chatbotBO.atualizarChatbot(chatbot);
            return Response.ok().entity(mensagem).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                           .entity("Erro ao atualizar chatbot: " + e.getMessage()).build();
        }
    }

    @DELETE
    @Path("/{idChatbot}/{cpfCliente}")
    public Response deletarChatbot(@PathParam("idChatbot") String idChatbot, @PathParam("cpfCliente") String cpfCliente) {
        try {
            if (idChatbot == null || cpfCliente == null) {
                return Response.status(Response.Status.BAD_REQUEST).entity("ID do chatbot e CPF do cliente são obrigatórios.").build();
            }

            String mensagem = chatbotBO.deletarChatbot(idChatbot, cpfCliente);
            return Response.ok().entity(mensagem).build();
        } catch (SQLException e) {
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                           .entity("Erro ao deletar chatbot: " + e.getMessage()).build();
        }
    }


    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<ChatbotVO> listarChatbots() throws SQLException {
        return chatbotBO.listarChatbots();
    }
}
