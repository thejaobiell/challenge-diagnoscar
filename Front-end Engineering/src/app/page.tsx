'use client'
import { useEffect } from 'react';
import styles from './Menu/Menu.module.css';
import Link from 'next/link'; 


const Menu = () => {
    useEffect(() => {
        document.title = "Menu - DiagnosCAR";
        const link = document.createElement('link');
        link.rel = 'icon';
        link.href = '/img/Logos/Diagnoscar.ico';
        document.head.appendChild(link);
    }, []);

    return (
        <section className={styles.sectionMenu}>

            <div className={styles.fundoContainer}>
                <img className={styles.fundo} src="/img/fundo.png" alt="Foto de Fundo" />

                <article className={styles.botaoEtexto}>
                    <h1 className={styles.texto}>
                        A inteligência artificial que irá fazer um pré-diagnóstico do seu carro antes dele ir para oficina
                    </h1>

                    <Link href="/Login">
                        <button className={styles.botao}>Entrar no DiagnosCAR</button>
                    </Link>

                </article>
                
            </div>

        </section>
    );
};

export default Menu;

