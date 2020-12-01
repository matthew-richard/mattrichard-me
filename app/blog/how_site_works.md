# How I Built This Site #


## A Note On Virtualization ##

I'd hesitate to say this site is "containerized", since it doesn't follow the Docker convention of keeping about one process per container. Instead, I install a bunch of packages to one Ubuntu 18.04 LTS image and effectively treat it as my own little virtual machine. In some sense I'm using Docker in the way [Vagrant](https://www.vagrantup.com/) is intended to be used.

There are some limitations to this approach compared to a full fledged virtual machine, namely that [you can't make systemd services in Docker containers](https://stackoverflow.com/questions/60928901/systemctl-command-doesnt-work-inside-docker-container), but for the most part I'm quite satisfied with it.

So, though the site isn't quite containerized, it's certainly virtualized. End of thought.


## Future work ##

* Use separate containers for nginx and certbot processes, to be more compliant with Docker standards