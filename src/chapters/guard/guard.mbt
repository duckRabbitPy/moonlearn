pub(all) struct User {
  id : Int
  name : String
  email: String?
  verified : Bool
}

pub struct Profile {
  name : String
  email : String
} derive(Eq, Show)

pub fn getVerifiedProfile(users : Map[String, User], id : String) -> Profile? {
  guard users.get(id) is Some(user) else { return None }
  guard user.email is Some(email) else { return None }
  guard user.verified else { return None }

 let profile = Profile::{ name: user.name, email: email }
 return Some(profile)
}