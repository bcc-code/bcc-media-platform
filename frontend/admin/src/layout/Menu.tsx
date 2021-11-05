import * as React from 'react';
import { styled } from '@mui/material/styles';
import { ReactNode } from 'react';
import PropTypes from 'prop-types';
import { shallowEqual, useSelector } from 'react-redux';
import lodashGet from 'lodash/get';
import DefaultIcon from '@mui/icons-material/ViewList';
import classnames from 'classnames';
import { useGetResourceLabel, getResources, ReduxState } from 'ra-core';
import { DashboardMenuItem, MenuItemLink, MenuProps } from 'react-admin';

export const Menu = (props: MenuProps) => {
    const resources = useSelector(getResources, shallowEqual) as Array<any>;
    const getResourceLabel = useGetResourceLabel();
    const {
        hasDashboard,
        dense,
        children = (
            <>
                {hasDashboard && <DashboardMenuItem dense={dense} />}
                {resources
                    .filter(r => r.hasList)
                    .map(resource => (
                        <StyledMenuLink
                            key={resource.name}
                            to={{
                                pathname: `/${resource.name}`,
                                state: { _scrollToTop: true },
                            }}
                            primaryText={resource.name}
                            leftIcon={
                                resource.icon ? (
                                    <resource.icon />
                                ) : (
                                    <DefaultIcon />
                                )
                            }
                            dense={dense}
                        />
                    ))}
            </>
        ),
        className,
        ...rest
    } = props;

    const open = useSelector((state: ReduxState) => state.admin.ui.sidebarOpen);

    return (
        <Root
            className={classnames(
                MenuClasses.main,
                {
                    [MenuClasses.open]: open,
                    [MenuClasses.closed]: !open,
                },
                className
            )}
            {...rest}
        >
            {children}
        </Root>
    );
};

Menu.propTypes = {
    className: PropTypes.string,
    dense: PropTypes.bool,
    hasDashboard: PropTypes.bool,
};

const PREFIX = 'RaMenu';

export const MenuClasses = {
    main: `${PREFIX}-main`,
    open: `${PREFIX}-open`,
    closed: `${PREFIX}-closed`,
};

const StyledMenuLink = styled(MenuItemLink)(({ theme }) => ({
    textTransform: 'capitalize'
}));

const Root = styled('div', { name: PREFIX })(({ theme }) => ({
    [`&.${MenuClasses.main}`]: {
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'flex-start',
        marginTop: '2em',
        marginBottom: '1em',
        [theme.breakpoints.only('xs')]: {
            marginTop: 0,
        },
        transition: theme.transitions.create('width', {
            easing: theme.transitions.easing.sharp,
            duration: theme.transitions.duration.leavingScreen,
        }),
    },

    [`&.${MenuClasses.open}`]: {
        width: lodashGet(theme, 'menu.width', MENU_WIDTH),
    },

    [`&.${MenuClasses.closed}`]: {
        width: lodashGet(theme, 'menu.closedWidth', CLOSED_MENU_WIDTH),
    },
}));

export const MENU_WIDTH = 240;
export const CLOSED_MENU_WIDTH = 55;