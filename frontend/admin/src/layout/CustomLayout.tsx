import * as React from 'react';
import { useSelector } from 'react-redux';
import { Layout, LayoutProps } from 'react-admin';
import { Menu } from './Menu';
import { darkTheme, lightTheme } from '../themes';

export const BtvLayout = (props: LayoutProps) => {
    const theme = useSelector((state: any) =>
        state.theme === 'light' ? lightTheme : darkTheme
    );
    return <Layout {...props} menu={Menu} theme={theme} />;
};