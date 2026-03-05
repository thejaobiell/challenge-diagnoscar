'use client'
import { useEffect } from "react";
import styles from "./Membros.module.css";

const Membros = () => {
    useEffect(() => {
        document.title = "Membros - DiagnosCAR";
        const link = document.createElement('link');
        link.rel = 'icon';
        link.href = '/img/Logos/Diagnoscar.ico';
        document.head.appendChild(link);
    }, []);


    return (
        <section className={styles.membrosContainer}>
            <div className={styles.membro}>
                <img
                    className="Joao"
                    src="img/membros/JoaoGabriel.jpg"
                    alt="João Gabriel Boaventura Marques e Silva"
                />
                <h1>João Gabriel Boaventura Marques e Silva - RM554874</h1>
            </div>

            <div className={styles.membro}>
                <img
                    className="Melo"
                    src="img/membros/LucasMelo.jpg"
                    alt="Lucas de Melo Pinho Pinheiro"
                />
                <h1>Lucas de Melo Pinho Pinheiro - RM558791</h1>
            </div>

            <div className={styles.membro}>
                <img
                    className="Leal"
                    src="img/membros/LucasLeal.jpg"
                    alt="Lucas Leal das Chagas"
                />
                <h1>Lucas Leal das Chagas - RM551124</h1>
            </div>
        </section>
    );
};

export default Membros;
