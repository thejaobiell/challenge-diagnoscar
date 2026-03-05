import '../styles/global.css';  
import type { Metadata } from "next";
import Header from './Header/page'; 
import Footer from './Footer/Footer';
import styles from '../styles/layout.module.css';

export const metadata: Metadata = {
  title: "DiagnosCAR"
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="pt-br">
      <body className={styles.rootLayout}>
        <Header />
        <div className={styles.content}>{children}</div> 
        <Footer />
      </body>
    </html>
  );
}
