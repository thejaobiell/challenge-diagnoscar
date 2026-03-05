'use client';
import Link from 'next/link';
import styles from './ObrigadoPorUsar.module.css';
import { useEffect, useState } from 'react';

const ObrigadoPorUsar = () => {
    const [visitaDetails, setVisitaDetails] = useState<any>(null);
    const [guinchoDetails, setGuinchoDetails] = useState<any>(null);

    useEffect(() => {
        document.title = "Obrigado por usar a DiagnosCAR!";
        const link = document.createElement('link');
        link.rel = 'icon';
        link.href = '/img/Logos/Diagnoscar.ico';
        document.head.appendChild(link);

        const details = JSON.parse(sessionStorage.getItem('agendamento') || 'null');
        setVisitaDetails(details);

        const guinchoInfo = JSON.parse(sessionStorage.getItem('localizacao') || 'null');
        setGuinchoDetails(guinchoInfo);
    }, []);

    return (
        <div className={styles.thanks}>
            <h1 className={styles.titulo}>Obrigado por usar a DiagnosCAR!</h1>

            {visitaDetails ? (
                <div className={styles.visitaInfo}>
                    <h2>Detalhes da Visita:</h2>
                    <p><strong>Oficina:</strong> {visitaDetails.oficina.Nome_Oficina}</p>
                    <p><strong>Endereço:</strong> {visitaDetails.oficina.Endereco_Oficina}</p>
                    <p><strong>CNPJ:</strong> {visitaDetails.oficina.Cnpj_Oficina}</p>
                    <p><strong>Especialização:</strong> {visitaDetails.oficina.Especializacao_Oficina}</p>
                    <p><strong>Avaliação:</strong> {visitaDetails.oficina.Avaliacao_Oficina}</p>
                    <p><strong>Data:</strong> {visitaDetails.dataVisita}</p>
                    <p><strong>Hora:</strong> {visitaDetails.horaVisita}</p>
                </div>
            ) : (
                <p>Nenhum detalhe de visita encontrado.</p>
            )}

            {guinchoDetails ? (
                <div className={styles.guinchoInfo}>
                    <h2>Detalhes do Guincho Chamado:</h2>
                    <p><strong>Rua:</strong> {guinchoDetails.rua || 'Não disponível'}</p>
                    <p><strong>Bairro:</strong> {guinchoDetails.bairro || 'Não disponível'}</p>
                    <p><strong>Cidade:</strong> {guinchoDetails.cidade || 'Não disponível'}</p>
                    <p><strong>Estado:</strong> {guinchoDetails.estado || 'Não disponível'}</p>
                    <p><strong>CEP:</strong> {guinchoDetails.cep || 'Não disponível'}</p>
                    <p><strong>Latitude:</strong> {guinchoDetails.latitude}</p>
                    <p><strong>Longitude:</strong> {guinchoDetails.longitude}</p>
                </div>
            ) : (
                <p>Nenhum detalhe do guincho encontrado.</p>
            )}

            <Link href="/Dashboard"> 
                <button className={styles.botao}>
                    Voltar ao Menu
                </button>
            </Link>
        </div>
    );
};

export default ObrigadoPorUsar;
