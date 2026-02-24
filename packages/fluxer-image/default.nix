{ pkgs, ... }:

pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fluxerapp/fluxer";
  imageDigest = "sha256:7bc...your_digest_here...";
  sha256 = "sha256-..........................";
  finalImageName = "fluxer";
  finalImageTag = "latest";
}
