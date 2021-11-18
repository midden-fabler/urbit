#include "all.h"

u3_noun
u3qdu_rlsin(u3_noun n_a, u3_noun l_a, u3_noun m_a, u3_noun r_a)
{
  if ( c3n == u3du(r_a) ) {
    return u3m_bail(c3__exit);
  }

  u3_noun n_b, l_b, m_b, r_b;

  u3_noun b = u3t(u3t(r_a));

  u3x_qual(b, &n_b, &l_b, &m_b, &r_b);

  u3_noun hor = u3h(r_a);

  if ( c3n == u3ud(hor) ) {
    return u3m_bail(c3__exit);
  }
  else switch ( hor ) {
    default:
      return u3m_bail(c3__exit);

    case c3__llos: {
      return u3qdu_rlos(
               u3k(n_a),
               u3qdu_rlos(u3k(n_b), u3k(l_a), u3k(m_a), u3k(l_b)),
               u3k(m_b),
               u3k(r_b));
    }

    case c3__rlos: {
      return u3qdu_rlos(
               u3k(n_b),
               u3qdu_rlos(u3k(n_a), u3k(l_a), u3k(m_a), u3k(l_b)),
               u3k(m_b),
               u3k(r_b));
    }
  }
}

u3_noun
u3wdu_rlsin(u3_noun cor)
{
  u3_noun a;

  if ( (c3n == u3r_mean(cor, u3x_sam, &a, 0 )) ||
       (c3n == u3du(a)) )
  {
    return u3m_bail(c3__exit);
  } else {
    u3_noun n, l, m, r;
    u3x_qual(a, &n, &l, &m, &r);

    if ( (c3n == u3du(n)) || (c3n == u3ud(m)) ) {
      return u3m_bail(c3__exit);
    }
    else {
      return u3qdu_rlsin(n, l, m, r);
    }
  }
}
