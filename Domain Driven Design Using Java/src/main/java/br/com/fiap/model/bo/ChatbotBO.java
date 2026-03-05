package br.com.fiap.model.bo;

import br.com.fiap.model.dao.ChatbotDAO;
import br.com.fiap.model.vo.ChatbotVO;

import java.sql.SQLException;
import java.util.List;

public class ChatbotBO {
    
    private ChatbotDAO chatbotDAO;

    public ChatbotBO() throws ClassNotFoundException, SQLException {
        chatbotDAO = new ChatbotDAO();
    }

    public String cadastrarChatbot(ChatbotVO chatbot) throws SQLException {
        return chatbotDAO.ChatbotDAO_inserir(chatbot);
    }

    public String atualizarChatbot(ChatbotVO chatbot) throws SQLException {
        return chatbotDAO.ChatbotDAO_atualizar(chatbot);
    }

    public String deletarChatbot(String idChatbot, String cpfCliente) throws SQLException {
        return chatbotDAO.ChatbotDAO_deletar(idChatbot, cpfCliente);
    }

    public List<ChatbotVO> listarChatbots() throws SQLException {
        return chatbotDAO.ChatbotDAO_selecionar();
    }
}
