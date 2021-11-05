import { createTheme } from '@mui/material';

export type ThemeName = 'light' | 'dark';

export const lightTheme = createTheme({
  palette: {
    mode: 'light',
    primary: {
      main: '#1D2838',
    },
    secondary: {
      main: '#E63C62',
    },
    info: {
      main: '#6EB0E6',
    },
    success: {
      main: '#71D2A4',
    },
    error: {
      main: '#E63C62',
    },
    warning: {
      main: '#FDCF48',
    },
  },
});

export const darkTheme = createTheme({
  palette: {
    mode: 'dark',
    primary: {
      main: '#6EB0E6',
      light: '#c1dbff',
      dark: '#0D1623',
    },
    secondary: {
      main: '#E63C62',
    },
    info: {
      main: '#6EB0E6',
    },
    background: {
      default: '#0D1623',
      paper: '#141E2D',
    },
    grey: {
      50: '#fafafa',
      100: '#f5f5f5',
      200: '#eeeeee',
      300: '#e0e0e0',
      400: '#bdbdbd',
      500: '#9e9e9e',
      600: '#757575',
      700: '#616161',
      800: '#424242',
      900: '#141E2D',
      A100: '#f5f5f5',
      A200: '#eeeeee',
      A400: '#bdbdbd',
      A700: '#616161',
    }, 
    success: {
      main: '#71D2A4',
    },
    error: {
      main: '#EB3B67',
    },
    warning: {
      main: '#FDCF48',
    },
    text: {
      primary: '#fefefe',
      secondary: '#B4C0D2',
      disabled: '#707C8E',
    },
    divider: '#3D4754',
  },
  typography: {
    fontFamily: 'Barlow',
    fontSize: 16,
    button: {
      fontWeight: 700,
      textTransform: 'inherit'
    },
  },
});