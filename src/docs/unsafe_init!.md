    Recyclers.unsafe_init!(recycler) -> recycler

Re-initialize `recycler`.  It is unsafe in the sense that there is no protection against
accesses from other tasks; i.e., the programmer calling this function is responsible for
ensuring that no concurrent tasks are accessing `recycler`.
