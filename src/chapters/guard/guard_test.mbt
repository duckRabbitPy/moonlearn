test "getVerifiedProfile" {

  let user1 = @guard.User::{ id: 1, name: "John", email: Some("john@example.com"), verified: true }
  let user2 = @guard.User::{ id: 2, name: "Jane", email: None, verified: false }
  let user3 = @guard.User::{ id: 3, name: "Jim", email: Some("jim@example.com"), verified: true }

  let users = { "1": user1, "2": user2, "3": user3 }

  let profile1 = @guard.getVerifiedProfile(users, "1")
  let expectedProfile1 = @guard.Profile::{ name: "John", email: "john@example.com" }
  assert_eq(profile1, Some(expectedProfile1))
  
}