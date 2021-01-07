import React, { Component } from "react"
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
      url: '/relationships',
      dataType: 'json',
      contentType: 'application/json',
      data: JSON.stringify({
        follow_id: this.props.user.id
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
        follow_id: this.props.user.id
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

  followFeature(e, isFollowing) {
    e.preventDefault();
    isFollowing ? this.unfollow() : this.follow();
  }

  render() {
    const isFollowing = this.state.relationship !== null
    return (
      <button
        onClick={ (e) => this.followFeature(e, isFollowing) }
        className="btn btn-primary follow-btn"
      >
        { isFollowing ? 'フォロー中' : 'フォロー' }
      </button>
    )
  }
}
