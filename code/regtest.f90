module regtest
contains
  ! prints the greatest discrepancy betweeen two arrays (on every task)
  subroutine print_arraydiff_1(verbose, arname, ar1, ar2)
    use gem_com
    logical :: verbose
    character(len=*) :: arname
    real(8) :: ar1(:), ar2(:)

    integer :: ldims(1), udims(1), maxijk(3)
    integer :: i, j, k

    real(8) :: diff, maxdiff, value1, value2
    real(8) :: value1_ar(0:numprocs-1)
    real(8) :: value2_ar(0:numprocs-1)
    integer :: maxijk_ar(0:3*numprocs-1)

    ! only use overlapping array parts
    ! (should be entire arrays, but it's good to check)
    ldims = max(lbound(ar1), lbound(ar2))
    udims = min(ubound(ar1), ubound(ar2))

    ! determine location and value of max discrepancy
    maxdiff = 0
    maxijk = [ldims(1), 0, 0]

    do i = ldims(1), udims(1)
       diff = abs(ar1(i) - ar2(i))
       if (diff > maxdiff) then
          value1 = ar1(i)
          value2 = ar2(i)
          maxdiff = diff
          maxijk = [i, i, i]
       end if
    end do

    ! master thread gathers data
    call MPI_GATHER(value1, 1, MPI_REAL8, value1_ar, 1, MPI_REAL8,&
         master, MPI_COMM_WORLD, ierr)
    call MPI_GATHER(value2, 1, MPI_REAL8, value2_ar, 1, MPI_REAL8,&
         master, MPI_COMM_WORLD, ierr)
    call MPI_GATHER(maxijk, 3, MPI_INTEGER, maxijk_ar, 3, MPI_INTEGER,&
         master, MPI_COMM_WORLD, ierr)

    ! master thread prints data
    ! <varname> max diff (<id>): <diff> (<value1> vs <value2>) at <i>,<j>,<k>
    if (myid == master) then
       ! find largest error overall
       do i = 0, numprocs - 1
          diff = abs(value1_ar(i) - value2_ar(i))
          if (diff > maxdiff) maxdiff = diff
       end do

       if (maxdiff == 0) write (*,'(A,A)') arname, ': no discrepancies found'

       do i = 0, numprocs - 1
          ! if verbose flag is set, print all
          ! else, print largest and all those within 5%
          diff = abs(value1_ar(i) - value2_ar(i))
          if (verbose .or. diff / maxdiff .ge. 0.95) then
             write (*,'(A,A,I0.4)',advance='no') arname, ' max diff (', i
             write (*,'(A,ES12.5,A)',advance='no') '): ', diff, ' ('
             write (*,'(ES12.5,A)',advance='no') value1_ar(i), ' vs '
             write (*,'(ES12.5,A)',advance='no') value2_ar(i), ') at '
             write (*,'(I0)') maxijk_ar(3*i)
          end if
       end do
    end if
  end subroutine print_arraydiff_1

  subroutine print_arraydiff_2(verbose, arname, ar1, ar2)
    use gem_com
    logical :: verbose
    character(len=*) :: arname
    real(8) :: ar1(:,:), ar2(:,:)

    integer :: ldims(2), udims(2), maxijk(3)
    integer :: i, j, k

    real(8) :: diff, maxdiff, value1, value2
    real(8) :: value1_ar(0:numprocs-1)
    real(8) :: value2_ar(0:numprocs-1)
    integer :: maxijk_ar(0:3*numprocs-1)

    ! only use overlapping array parts
    ! (should be entire arrays, but it's good to check)
    ldims = max(lbound(ar1), lbound(ar2))
    udims = min(ubound(ar1), ubound(ar2))

    ! determine location and value of max discrepancy
    maxdiff = 0
    maxijk = [ldims(1), ldims(2), ldims(2)]

    do i = ldims(1), udims(1)
       do j = ldims(2), udims(2)
          diff = abs(ar1(i,j) - ar2(i,j))
          if (diff > maxdiff) then
             value1 = ar1(i,j)
             value2 = ar2(i,j)
             maxdiff = diff
             maxijk = [i,j,j]
          end if
       end do
    end do

    ! master thread gathers data
    call MPI_GATHER(value1, 1, MPI_REAL8, value1_ar, 1, MPI_REAL8,&
         master, MPI_COMM_WORLD, ierr)
    call MPI_GATHER(value2, 1, MPI_REAL8, value2_ar, 1, MPI_REAL8,&
         master, MPI_COMM_WORLD, ierr)
    call MPI_GATHER(maxijk, 3, MPI_INTEGER, maxijk_ar, 3, MPI_INTEGER,&
         master, MPI_COMM_WORLD, ierr)

    ! master thread prints data
    ! <varname> max diff (<id>): <diff> (<value1> vs <value2>) at <i>,<j>,<k>
    if (myid == master) then
       ! find largest error overall
       do i = 0, numprocs - 1
          diff = abs(value1_ar(i) - value2_ar(i))
          if (diff > maxdiff) maxdiff = diff
       end do

       if (maxdiff == 0) write (*,'(A,A)') arname, ': no discrepancies found'

       do i = 0, numprocs - 1
          ! if verbose flag is set, print all
          ! else, print largest and all those within 5%
          diff = abs(value1_ar(i) - value2_ar(i))
          if (verbose .or. diff / maxdiff .ge. 0.95) then
             write (*,'(A,A,I0.4)',advance='no') arname, ' max diff (', i
             write (*,'(A,ES12.5,A)',advance='no') '): ', diff, ' ('
             write (*,'(ES12.5,A)',advance='no') value1_ar(i), ' vs '
             write (*,'(ES12.5,A)',advance='no') value2_ar(i), ') at '
             write (*,'(I0,A)',advance='no') maxijk_ar(3*i), ','
             write (*,'(I0)') maxijk_ar(3*i+1)
          end if
       end do
    end if
  end subroutine print_arraydiff_2

  subroutine print_arraydiff_3(verbose, arname, ar1, ar2)
    use gem_com
    logical :: verbose
    character(len=*) :: arname
    real(8) :: ar1(:,:,:), ar2(:,:,:)

    integer :: ldims(3), udims(3), maxijk(3)
    integer :: i, j, k

    real(8) :: diff, maxdiff, value1, value2
    real(8) :: value1_ar(0:numprocs-1)
    real(8) :: value2_ar(0:numprocs-1)
    integer :: maxijk_ar(0:3*numprocs-1)

    ! only use overlapping array parts
    ! (should be entire arrays, but it's good to check)
    ldims = max(lbound(ar1), lbound(ar2))
    udims = min(ubound(ar1), ubound(ar2))

    ! determine location and value of max discrepancy
    maxdiff = 0
    maxijk = ldims

    do i = ldims(1), udims(1)
       do j = ldims(2), udims(2)
          do k = ldims(3), udims(3)
             diff = abs(ar1(i,j,k) - ar2(i,j,k))
             if (diff > maxdiff) then
                value1 = ar1(i,j,k)
                value2 = ar2(i,j,k)
                maxdiff = diff
                maxijk = [i,j,k]
             end if
          end do
       end do
    end do

    ! master thread gathers data
    call MPI_GATHER(value1, 1, MPI_REAL8, value1_ar, 1, MPI_REAL8,&
         master, MPI_COMM_WORLD, ierr)
    call MPI_GATHER(value2, 1, MPI_REAL8, value2_ar, 1, MPI_REAL8,&
         master, MPI_COMM_WORLD, ierr)
    call MPI_GATHER(maxijk, 3, MPI_INTEGER, maxijk_ar, 3, MPI_INTEGER,&
         master, MPI_COMM_WORLD, ierr)

    ! master thread prints data
    ! <varname> max diff (<id>): <diff> (<value1> vs <value2>) at <i>,<j>,<k>
    if (myid == master) then
       ! find largest error overall
       do i = 0, numprocs - 1
          diff = abs(value1_ar(i) - value2_ar(i))
          if (diff > maxdiff) maxdiff = diff
       end do

       if (maxdiff == 0) write (*,'(A,A)') arname, ': no discrepancies found'

       do i = 0, numprocs - 1
          ! if verbose flag is set, print all
          ! else, print largest and all those within 5%
          diff = abs(value1_ar(i) - value2_ar(i))
          if (verbose .or. diff / maxdiff .ge. 0.95) then
             write (*,'(A,A,I0.4)',advance='no') arname, ' max diff (', i
             write (*,'(A,ES12.5,A)',advance='no') '): ', diff, ' ('
             write (*,'(ES12.5,A)',advance='no') value1_ar(i), ' vs '
             write (*,'(ES12.5,A)',advance='no') value2_ar(i), ') at '
             write (*,'(I0,A)',advance='no') maxijk_ar(3*i), ','
             write (*,'(I0,A,I0)') maxijk_ar(3*i+1), ',', maxijk_ar(3*i+2)
          end if
       end do
    end if
  end subroutine print_arraydiff_3

  !!!! REGRESSION TESTING FOR ENTIRE PROGRAM !!!!

  ! main regtest function
  subroutine regtest_main(refrun, datadir, tmpname)
    use gem_com
    implicit none
    logical :: refrun ! whether this is a reference run
    character(len=*) :: datadir
    character(len=*) :: tmpname

    real(8),dimension(:,:),allocatable :: x3_new, w3_new, u3_new
    real(8),dimension(:,:,:,:),allocatable :: den_new

    integer :: i, j, k

    if (refrun) then
       call regtest_main_outsave(datadir, tmpname)
    else
       ! copy output to new arrays, as outload will overwrite them
       allocate(x3_new(nsmx,1:mmx))
       allocate(w3_new(nsmx,1:mmx))
       allocate(u3_new(nsmx,1:mmx))
       allocate(den_new(nsmx,0:nxpp,0:jmx,0:1))
       x3_new = x3
       w3_new = w3
       u3_new = u3
       den_new = den

       call regtest_main_outload(datadir, tmpname)

       ! print largest differences between old and new arrays
       call print_arraydiff_2(.False., 'x3', x3, x3_new)
       call print_arraydiff_2(.False., 'w3', w3, w3_new)
       call print_arraydiff_2(.False., 'u3', u3, u3_new)
       call print_arraydiff_3(.False., 'den(:,:,:,0)', den(:,:,:,0), den_new(:,:,:,0))
       call print_arraydiff_3(.False., 'den(:,:,:,1)', den(:,:,:,1), den_new(:,:,:,1))

       deallocate(x3_new, w3_new, u3_new, den_new)
    end if
  end subroutine regtest_main

  ! this function serializes the output for a reference run or test run of main
  ! file name is <datadir>/main.<tmpname>.<id>.out.regtest
  subroutine regtest_main_outsave(datadir, tmpname)
    use gem_com
    use gem_equil
    implicit none
    character(len=*) :: datadir
    character(len=*) :: tmpname
    character(len=4) :: myidstring
    character(len=1024) :: regfname

    ! determine filename
    write (myidstring, '(I0.4)') myid
    regfname = datadir//'/main.'//tmpname//'.'//myidstring//'.out.regtest'

    open(unit=525, file=regfname, &
         form='unformatted', action='write', status='replace')

    ! write output vars
    write (525) x3
    write (525) w3
    write (525) u3
    write (525) den

    close(525)
  end subroutine regtest_main_outsave

  ! loads output variables for comparison
  subroutine regtest_main_outload(datadir, tmpname)
    use gem_com
    use gem_equil
    implicit none
    character(len=*) :: datadir
    character(len=*) :: tmpname
    character(len=4) :: myidstring
    character(len=1024) :: regfname

    ! determine filename
    write (myidstring, '(I0.4)') myid
    regfname = datadir//'/main.'//tmpname//'.'//myidstring//'.out.regtest'

    open(unit=525, file=regfname, form='unformatted', action='read')

    ! read vars
    read (525) x3
    read (525) w3
    read (525) u3
    read (525) den

    close(525)
  end subroutine regtest_main_outload
end module regtest
