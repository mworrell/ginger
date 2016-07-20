%% @author Driebit <tech@driebit.nl>
%% @copyright 2016

-module(mod_ginger_remark).
-author("Driebit <tech@driebit.nl>").

-mod_title("Ginger remark").
-mod_description("Enables simple adding of resources.").

-include_lib("zotonic.hrl").

-mod_prio(250).
-mod_schema(9).

-export([
    manage_schema/2,
    observe_rsc_update/3,
    observe_acl_is_allowed/2,
    observe_acl_is_allowed_prop/2,
    observe_rsc_update_done/2,
    notify_followers/2
]).

manage_schema(_Version, Context) ->
  m_config:set_value(i18n, language, nl, Context),
  #datamodel{
    categories=[
        {remark, text, [
            {title, {trans, [{nl, <<"Opmerking">>},
                             {en, <<"Remark">>}]}},
            {language, [en,nl]}
        ]}
    ],
    predicates=[
        {follow, [
          {title, {trans, [{nl, <<"Volg">>},
                           {en, <<"Follow">>}]}}
          ], [
          {person, undefined}
        ]}
    ],
    resources=[
        {cg_user_generated, content_group, [
          {title, <<"User generated">>}
        ]}
    ],
    media=[
    ],
    edges=[
    ],
    data = [
        {acl_rules, [
            {rsc, [
                {acl_user_group_id, acl_user_group_anonymous},
                {actions, [insert, update]},
                {category_id, remark},
                {content_group_id, m_rsc:rid(cg_user_generated, Context)}
            ]},
            {rsc, [
                {acl_user_group_id, acl_user_group_anonymous},
                {actions, [insert]},
                {category_id, media},
                {content_group_id, m_rsc:rid(cg_user_generated, Context)}
            ]},
            {rsc, [
                {acl_user_group_id, acl_user_group_members},
                {actions, [update, link, delete]},
                {category_id, remark},
                {content_group_id, m_rsc:rid(cg_user_generated, Context)},
                {is_owner, true}
            ]}
        ]}
    ]}.

is_owner(Id, #context{user_id=undefined, session_id=SessionId} = Context) ->
    case m_rsc:p_no_acl(Id, session_owner, Context) of
         undefined -> false;
         SessionOwner -> SessionId == SessionOwner
    end.

observe_acl_is_allowed_prop(#acl_is_allowed_prop{action=view, prop=session_owner}, _Context) ->
    false;
observe_acl_is_allowed_prop(#acl_is_allowed_prop{}, _Context) ->
    undefined.

observe_rsc_update(#rsc_update{action=insert},
                   {_IsChanged, UpdateProps},
                   #context{session_id=SessionId, user_id=undefined}) ->
    Props = lists:keystore(session_owner, 1, UpdateProps, {session_owner, SessionId}),
    {true, Props};
observe_rsc_update(#rsc_update{}, Acc, _Context) ->
    Acc.

observe_acl_is_allowed(#acl_is_allowed{action=view, object=RscId},
                       #context{user_id=undefined} = Context) when is_integer(RscId) ->
    case is_owner(RscId, Context) of
        true -> true;
        false -> undefined
    end;
observe_acl_is_allowed(#acl_is_allowed{action=update, object=RscId},
                       #context{user_id=undefined} = Context) when is_integer(RscId) ->
    is_owner(RscId, Context);
observe_acl_is_allowed(#acl_is_allowed{action=insert, object=#acl_edge{subject_id=RscId}},
                       #context{user_id=undefined} = Context) ->
    is_owner(RscId, Context);
observe_acl_is_allowed(#acl_is_allowed{}, _Context) ->
    undefined.
    
notify_followers(RemarkId, Context) ->
    About = m_rsc:o(RemarkId, about, 1, Context),
    {rsc_list, Followers} = m_rsc:s(About, follow, Context),
    Vars = [ {about, About},
             {remark, RemarkId}],
    lists:foreach(
        fun(Follower) ->
            Email = m_rsc:p(Follower, email, Context),
            z_email:send_render(Email, "_email-follow.tpl", Vars, z_acl:sudo(Context))
        end,
        Followers
    ),
    ok.

observe_rsc_update_done(#rsc_update_done{action = insert, id = RemarkId, post_is_a = [text,remark], post_props = PostProps}, Context) ->
    PostVersion = proplists:get_value(version, PostProps),
    PostPublished = proplists:get_value(is_published, PostProps),
    case (PostVersion == 3) and (PostPublished == true) of
        true ->
            notify_followers(RemarkId, Context);
        false ->
            undefined
    end;
observe_rsc_update_done(#rsc_update_done{action = update, id = RemarkId, post_is_a = [text,remark], pre_props = PreProps, post_props = PostProps}, Context) ->
    PostVersion = proplists:get_value(version, PostProps),
    PrePublished = proplists:get_value(is_published, PreProps),
    case (PostVersion == 4) and (PrePublished == false) of
        true ->
            notify_followers(RemarkId, Context);
        false ->
            undefined
    end;
observe_rsc_update_done(#rsc_update_done{}, _Context) ->
    undefined.
