import React from "react";
import { Link } from "react-router-dom";
// styles
import Divider from '@mui/material/Divider';
import List from "@material-ui/core/List";
import ListItem from "@material-ui/core/ListItem";
import ListItemIcon from "@material-ui/core/ListItemIcon";
import ListItemText from "@material-ui/core/ListItemText";
// アイコン
import CalendarTodayRoundedIcon from '@mui/icons-material/CalendarTodayRounded';

export const DiariesButton = (props) => {

  return (
    <>
      <Divider />
      <List>
        <ListItem
          button
          color="inherit"
          component={Link}
          to={`/users/${props.loginUserId}/books`}
        >
          <ListItemIcon>
            <CalendarTodayRoundedIcon />
          </ListItemIcon>
          <ListItemText primary='読んだ本/読む本' />
        </ListItem>
      </List>
    </>
  )
}