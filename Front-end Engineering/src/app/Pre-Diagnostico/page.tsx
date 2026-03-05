'use client';
import { useEffect, useState } from 'react';
import styles from './PreDiagnostico.module.css';
import { useRouter } from 'next/navigation';

interface Carro {
  placa: string;
  marca: string;
  modelo: string;
  ano: string;
}

const PreDiagnostico = () => {
  const [carroSelecionado, setCarroSelecionado] = useState<Carro | null>(null);
  const [mostrarChat, setMostrarChat] = useState<boolean>(false);
  const [mensagem, setMensagem] = useState<string>('');
  const [mensagensChat, setMensagensChat] = useState<{ texto: string; tipo: 'user' | 'bot' }[]>([]);
  const router = useRouter();

  useEffect(() => {
    const logado = sessionStorage.getItem('logado');
    if (logado !== 'sim') {
      router.push('/Login');
    }
  }, [router]);

  useEffect(() => {
    document.title = "Começando Pré-Diagnóstico - DiagnosCAR";
    const link = document.createElement('link');
    link.rel = 'icon';
    link.href = '/img/Logos/Diagnoscar.ico';
    document.head.appendChild(link);
  }, []);

  useEffect(() => {
    const carroSelecionadoStored = localStorage.getItem('carroSelecionado');
    if (carroSelecionadoStored) {
      setCarroSelecionado(JSON.parse(carroSelecionadoStored));
    }
  }, []);

  useEffect(() => {
    if (typeof window !== "undefined") {
      setMostrarChat(window.innerWidth >= 1200);
      const handleResize = () => {
        setMostrarChat(window.innerWidth >= 1200);
      };
      window.addEventListener('resize', handleResize);
      return () => window.removeEventListener('resize', handleResize);
    }
  }, []);

  useEffect(() => {
    if (mostrarChat && mensagensChat.length === 0) {
      const userInfo = JSON.parse(sessionStorage.getItem('cliente') || '{}'); // Usando 'cliente' para pegar o sessionStorage
      const carroSelecionadoStored = localStorage.getItem('carroSelecionado');
      setMensagensChat([{ texto: `Olá ${userInfo.nomeCliente} ${userInfo.sobrenomeCliente}, digite o problema do seu ${carroSelecionadoStored ? JSON.parse(carroSelecionadoStored).modelo : 'carro'}`, tipo: 'bot' }]);
    }
  }, [mostrarChat]);

  const chamarGuincho = () => {
    router.push('/Guincho');
  };

  const oficinasParceiras = () => {
    router.push('/Oficinas');
  };

  const enviarMensagem = () => {
    if (mensagem.trim()) {
      setMensagensChat((prev) => [...prev, { texto: mensagem, tipo: 'user' }]);
      setTimeout(() => {
        setMensagensChat((prev) => [...prev, { texto: `Resposta do DiagnosCAR: ${mensagem}`, tipo: 'bot' }]);
      }, 500);
      setMensagem('');
    }
  };

  const TrocarCarro = () => {
    setCarroSelecionado(null);
    router.push('/Dashboard');
  };

  return (
    <>
      <div className={`${styles.informacoes} ${mostrarChat ? styles.chatAberto : ''}`}>
        <h2>Informações: </h2>
        {carroSelecionado ? (
          <>
            <h4>Marca: {carroSelecionado.marca}</h4>
            <h4>Modelo: {carroSelecionado.modelo}</h4>
            <h4>Ano: {carroSelecionado.ano}</h4>
            <h4>Placa: {carroSelecionado.placa}</h4>
          </>
        ) : (
          <p>Nenhum carro selecionado.</p>
        )}
        <button className={styles.TrocarCarro} onClick={TrocarCarro}>Trocar de Carro</button>
      </div>

      <div className={styles.descricao}>
        <h2>Descrição do Problema:</h2>
        <p>Descrição gerada automaticamente ou preenchida pelo usuário.</p>
      </div>

      <div className={styles.preDiagnostico}>
        <h1>Pré-diagnóstico:</h1>
        <p>Possível diagnóstico será exibido aqui.</p>
      </div>

      <div className={styles.duplabotao}>
        <button className={styles.botao} onClick={chamarGuincho}>
          Chamar o Guincho
        </button>
        <button className={styles.botao} onClick={oficinasParceiras}>
          Oficinas Perto de Você
        </button>
      </div>

      {typeof window !== "undefined" && window.innerWidth < 1200 && (
        <div className={styles.solobotao}>
          <button className={`${styles.botao} ${styles.chatbotao}`} onClick={() => setMostrarChat(!mostrarChat)}>
            Chat
          </button>
        </div>
      )}

      {mostrarChat && (
        <div className={styles.chatContainer}>
          {typeof window !== "undefined" && window.innerWidth < 1200 && (
            <button className={styles.fecharChat} onClick={() => setMostrarChat(false)}>
              Fechar
            </button>
          )}
          <div className={styles.chatBox}>
            <div className={styles.mensagens}>
              {mensagensChat.map((msg, index) => (
                <p key={index} className={msg.tipo === 'user' ? styles.userMensagem : styles.iaMensagem}>
                  {msg.texto}
                </p>
              ))}
            </div>
            <div className={styles.inputContainer}>
              <input
                type="text"
                value={mensagem}
                onChange={(e) => setMensagem(e.target.value)}
                onKeyDown={(e) => e.key === 'Enter' && enviarMensagem()}
                placeholder="Digite sua mensagem"
                className={styles.inputChat}
              />
              <button onClick={enviarMensagem} className={styles.botaoEnviar}>
                Enviar
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default PreDiagnostico;
