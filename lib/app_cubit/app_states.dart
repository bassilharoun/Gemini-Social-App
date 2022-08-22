abstract class SocialStates {}

class SocialInitialStates extends SocialStates {}
class SocialGetUserSuccessState extends SocialStates {}
class SocialGetUserLoadingState extends SocialStates {}
class SocialGetUserErrorState extends SocialStates {
  final String Error ;
  SocialGetUserErrorState(this.Error);
}

class SocialGetAllUserSuccessState extends SocialStates {}
class SocialGetAllUserLoadingState extends SocialStates {}
class SocialGetAllUserErrorState extends SocialStates {
  final String Error ;
  SocialGetAllUserErrorState(this.Error);
}

class SocialGetPostsSuccessState extends SocialStates {}
class SocialGetPostsLoadingState extends SocialStates {}
class SocialGetPostsErrorState extends SocialStates {
  final String Error ;
  SocialGetPostsErrorState(this.Error);
}

class SocialGetSomeonePostsSuccessState extends SocialStates {}
class SocialGetSomeonePostsLoadingState extends SocialStates {}
class SocialGetSomeonePostsErrorState extends SocialStates {
  final String Error ;
  SocialGetSomeonePostsErrorState(this.Error);
}

class SocialLikePostSuccessState extends SocialStates {}
class SocialLikePostErrorState extends SocialStates {
  final String Error ;
  SocialLikePostErrorState(this.Error);
}

class SocialFollowSomeoneSuccessState extends SocialStates {}
class SocialFollowSomeoneErrorState extends SocialStates {
  final String Error ;
  SocialFollowSomeoneErrorState(this.Error);
}

class SocialChangeBottomNavBarState extends SocialStates {}

class SocialProfileImagePickedSuccessState extends SocialStates {}
class SocialProfileImagePickedErrorState extends SocialStates {}

class SocialCoverImagePickedSuccessState extends SocialStates {}
class SocialCoverImagePickedErrorState extends SocialStates {}

class SocialUploadProfileImageSuccessState extends SocialStates {}
class SocialUploadProfileImageErrorState extends SocialStates {}

class SocialUploadCoverImageSuccessState extends SocialStates {}
class SocialUploadCoverImageErrorState extends SocialStates {}

class SocialUserUpdateLoadingState extends SocialStates {}
class SocialUserUpdateErrorState extends SocialStates {}

class SocialCreatePostLoadingState extends SocialStates {}
class SocialCreatePostErrorState extends SocialStates {}
class SocialCreatePostSuccessState extends SocialStates {}

class SocialCommentLoadingState extends SocialStates {}
class SocialCommentErrorState extends SocialStates {}
class SocialCommentSuccessState extends SocialStates {}

class SocialGetCommentsLoadingState extends SocialStates {}
class SocialGetCommentsErrorState extends SocialStates {}
class SocialGetCommentsSuccessState extends SocialStates {}

class SocialGetAnotherUserLoadingState extends SocialStates {}
class SocialGetAnotherUserErrorState extends SocialStates {}
class SocialGetAnotherUserSuccessState extends SocialStates {}


class SocialPostImagePickedSuccessState extends SocialStates {}
class SocialPostImagePickedErrorState extends SocialStates {}

class SocialRemovePostImageState extends SocialStates {}

class SocialSendMessageErrorState extends SocialStates {}
class SocialSendMessageSuccessState extends SocialStates {}
class SocialGetMessagesErrorState extends SocialStates {}
class SocialGetMessagesSuccessState extends SocialStates {}

class SocialGetIsPostLikedSuccessState extends SocialStates {}
class SocialGetIsPostLikedLoadingState extends SocialStates {}

class SocialGetSearchUserSuccessState extends SocialStates {}
class SocialGetSearchUserErrorState extends SocialStates {}


