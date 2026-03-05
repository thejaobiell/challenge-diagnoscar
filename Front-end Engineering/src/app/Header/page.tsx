import styles from './Header.module.css';
import Link from 'next/link';
import localFont from 'next/font/local';

const fonto = localFont({
    src: "../../font/FugazOne-Regular.woff",
    variable: "--FontDifera",
    weight: "400",
});

const Header = () => {
    return (
        <main className={styles.main}>
            <header className={styles.header}>
                <div className={styles.headerContent}>
                    <Link href="/">
                        <img 
                            className={styles.logo} 
                            src="/img/Logos/Logo sem Nome.png" 
                            alt="DiagnoCAR Company Logo" 
                        />
                    </Link>

                    <h1 className={`${styles.Diagnoscar} ${fonto.variable}`}>
                        DiagnosCAR
                    </h1>
                </div>

                <nav>
                    <ul className={styles.navUl}>
                        <li className={styles.navLi}>
                            <Link className={styles.navLink} href="/">Home</Link>
                        </li>
                        <li className={styles.navLi}>
                            <Link className={styles.navLink} href="/Login">Login</Link>
                        </li>
                        <li className={styles.navLi}>
                            <Link className={styles.navLink} href="/Membros">Membros</Link>
                        </li>
                    </ul>
                </nav>
            </header>
        </main>
    );
};

export default Header;
