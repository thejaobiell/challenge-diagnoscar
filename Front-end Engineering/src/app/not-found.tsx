'use client'
import { useEffect } from "react";
import styles from "./Error404/Error404.module.css"
import Link from 'next/link';

const Error404 = () => {
    useEffect(() => {
        document.title = "Erro 404 - DiagnosCAR";
        const link = document.createElement('link');
        link.rel = 'icon';
        link.href = '/img/Logos/Diagnoscar.ico';
        document.head.appendChild(link);
    }, []);

  return (
    <div className={styles.j}>
      <h1 className={styles.error}>Erro 404</h1>
      <h2 className={styles.mensagem}>
        Ops! Infelizmente a página que você tentou acessar não existe.
      </h2>
      <Link href="/Menu">
        <button type="submit" className={styles.button}>Voltar</button>
      </Link>
    </div>
  );
};

export default Error404;
