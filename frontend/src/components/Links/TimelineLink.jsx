import React from 'react';
import { Link } from 'react-router-dom';
// Style
import Divider from '@mui/material/Divider';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListItemIcon from '@material-ui/core/ListItemIcon';
import ListItemText from '@material-ui/core/ListItemText';
// Icon
import DynamicFeedIcon from '@mui/icons-material/DynamicFeed';

export const TimelineLink = ({
  breakpoint,
  handleDrawerClose,
  loginUserId
}) => {
  return (
    <>
      <Divider />
      <List>
        <ListItem
          button
          component={Link}
          onClick={!breakpoint && (() => handleDrawerClose())}
          to={`/users/${loginUserId}/timeline`}
        >
          <ListItemIcon>
            <DynamicFeedIcon
              color='primary'
              sx={{ ml: 1 }}
            />
          </ListItemIcon>
          <ListItemText primary='タイムライン' />
        </ListItem>
      </List>
    </>
  )
}
