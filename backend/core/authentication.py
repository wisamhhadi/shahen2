from rest_framework import exceptions
from rest_framework.authentication import BaseAuthentication, get_authorization_header

from captain.models import CaptainToken
from deliverycompany.models import DeliveryCompanyToken
from mandob.models import MandobToken
from user.models import UserToken


class MultiModelTokenAuthentication(BaseAuthentication):
    keyword = 'token'
    token_models = (
        UserToken,
        CaptainToken,
        DeliveryCompanyToken,
        MandobToken,
    )

    def authenticate(self, request):
        auth = get_authorization_header(request).split()
        if not auth:
            return None

        if auth[0].lower() != self.keyword.encode():
            return None

        if len(auth) == 1:
            raise exceptions.AuthenticationFailed('Invalid token header. No credentials provided.')
        if len(auth) > 2:
            raise exceptions.AuthenticationFailed('Invalid token header.')

        try:
            key = auth[1].decode()
        except UnicodeError:
            raise exceptions.AuthenticationFailed('Invalid token header.')

        for token_model in self.token_models:
            try:
                token = token_model.objects.select_related('user').get(key=key)
                if not token.user.is_active:
                    raise exceptions.AuthenticationFailed('User inactive or deleted.')
                return token.user, token
            except token_model.DoesNotExist:
                continue

        raise exceptions.AuthenticationFailed('Invalid token.')

    def authenticate_header(self, request):
        return self.keyword
