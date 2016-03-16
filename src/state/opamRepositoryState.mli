(**************************************************************************)
(*                                                                        *)
(*    Copyright 2012-2015 OCamlPro                                        *)
(*    Copyright 2012 INRIA                                                *)
(*                                                                        *)
(*  All rights reserved.This file is distributed under the terms of the   *)
(*  GNU Lesser General Public License version 3.0 with linking            *)
(*  exception.                                                            *)
(*                                                                        *)
(*  OPAM is distributed in the hope that it will be useful, but WITHOUT   *)
(*  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY    *)
(*  or FITNESS FOR A PARTICULAR PURPOSE.See the GNU General Public        *)
(*  License for more details.                                             *)
(*                                                                        *)
(**************************************************************************)

open OpamTypes

open OpamStateTypes

(** Caching of repository loading (marshall of all parsed opam files) *)
module Cache: sig
  val save: repos_state -> unit
  val load: dirname -> OpamFile.OPAM.t package_map repository_name_map option
  val remove: unit -> unit
end

val load:
  ?save_cache:bool -> ?lock:lock_kind -> global_state -> repos_state

(** Returns the repo of origin and metadata corresponding to a package, if
    found, from a sorted list of repositories (highest priority first) *)
val find_package_opt: repos_state -> repository_name list -> package ->
  (repository_name * OpamFile.OPAM.t) option

(** Given the repos state, and a list of repos to use (highest priority first),
    build a map of all existing package definitions *)
val build_index:
  repos_state -> repository_name list -> OpamFile.OPAM.t OpamPackage.Map.t

(** List of repos name ordered by decreasing priority (note: this is at the
    moment included in the repos config, but is intended to move to the switch
    configs) *)
val repos_list: repos_state -> repository_name list

(** Load all the metadata within the local mirror of the given repository,
    without cache *)
val load_repo_opams: repository -> OpamFile.OPAM.t OpamPackage.Map.t

(** Downloads the repository-mirrored package archive into
    $opam/archives/$name.$version+opam.tar.gz if not already there, and
    returns the file name if found either way *)
val download_archive: repos_state -> repository_name list ->
  package -> filename option OpamProcess.job