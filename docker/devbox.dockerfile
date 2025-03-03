FROM python:3.11.4-buster

ARG _USER="instagrapi"
ARG _UID="1001"
ARG _GID="100"
ARG _SHELL="/bin/bash"

RUN useradd -m -s "${_SHELL}" -N -u "${_UID}" "${_USER}"

ENV USER ${_USER}
ENV UID ${_UID}
ENV GID ${_GID}
ENV HOME /home/${_USER}
ENV PATH "${HOME}/.local/bin/:${PATH}"
ENV PIP_NO_CACHE_DIR "true"

# Create application directories and ensure correct ownership
RUN mkdir /app && chown ${UID}:${GID} /app
RUN mkdir /app/downloads && chown ${UID}:${GID} /app/downloads

USER ${_USER}

# Copy only requirements for efficiency
COPY --chown=${UID}:${GID} ./requirements.txt /app/
# Copy the FastAPI script (main.py) from the root of your repository
COPY --chown=${UID}:${GID} ./main.py /app/
WORKDIR /app

# Install your application dependencies
RUN pip install -r requirements.txt && pip install fastapi uvicorn instagrapi

# Expose port 8000
EXPOSE 8000

# Run the API server on container startup
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
