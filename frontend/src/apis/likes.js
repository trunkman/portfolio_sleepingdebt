import axios from "axios";
import { like, unlike } from "../urls";

export const postLike = (params) => {
  return axios.post(like, {
    like: {
      user_id: params.userId,
      micropost_id: params.micropostId,
    }
  },
    { withCredentials: true }
  )
    .then(res => {
      if (res.data) {
        console.log('like#create', res);
        return res.data;
      }
    })
    .catch(error => {
      console.log('like#create', error)
      return 'nil'
    })
}

export const deleteLike = (params) => {
  return axios.delete(unlike(params.likeId), { withCredentials: true })
    .then(res => {
      console.log('like#destroy', res)
      return res.data
    })
    .catch(error => {
      console.log('like#destroy', error)
    })
}
