import React from "react"
// Proptypesは型チェックを行うためのプロパティ
import PropTypes from "prop-types"
import ReactDOM from "react-dom"

export default class FollowButton extends Component {
  constructor(props) {
    super(props)
    this.state = {
      relationship: props.relationship
    }
  }

  follow = () => {
    $.ajax({
      type: 'POST',
      url: '/relationship',
      dataType: 'json',
      contentType: 'application/json',
      data: JSON.stringify({
        followed_id: this.props.user.id
      }),
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      }
    }).then((response) =>{
      const relationship = response
      this.setState({
        relationship
      })
    })
  }

  unfollow = () => {
    $.ajax({
      type: 'DELETE',
      url: `/relationships/${this.state.relationship.id}`,
      dataType: 'json',
      contentType: 'application/json',
      data: JSON.stringify({
        followed_id: this.props.user.id
      }),
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      }
    }).then((response) => {
      this.setState({
        relationship: null
      })
    })
  }

  render() {
    const inFollowing = this.state.relationship !== null

    return (
      <button onClick={ isFollowing ? this.unfollow : this.follow }>
        { isFollowing ? 'Unfollow' : 'Follow' }
      </button>
    )
  }
}
