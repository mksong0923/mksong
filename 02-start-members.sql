-- 기존 로그인 계정 두 개를 researchtalk의 첫 참여자로 등록합니다.
-- 표시 이름은 앱의 '참여자 → 내 이름 바꾸기'에서 바꿀 수 있습니다.
begin;
lock table public.rt_members in share row exclusive mode;
insert into public.rt_members(user_id,name) values
 ('13e89a78-ec43-40aa-a1c1-242d818e4901','조성진'),
 ('705094cd-551c-402e-8322-8cf91c051f6f','조성순')
on conflict(user_id) do nothing;
do $$ begin
 if (select count(*) from public.rt_members)>6 then raise exception '참여자는 최대 여섯 명이에요.'; end if;
end $$;
insert into public.rt_signals(user_id) select user_id from public.rt_members on conflict do nothing;
commit;
select name as "이름",user_id as "계정 UID" from public.rt_members order by joined_at,user_id;
